# Collectd plugin for Chef and Ohai data

import collectd
import socket
import subprocess
import json

class ChefNode(object):
    def __init__(self, data):
        self.attributes = {}
        self.attributes.update(data['default'])
        self.attributes.update(data['normal'])
        self.attributes.update(data['override'])
        self.attributes.update(data['automatic'])

    def __getitem__(self, key):
        return self.attributes[key]

    def __getattr__(self, key):
        return self[key]


class ChefPlugin(object):
    def __init__(self):
        self.verbose = False
        self.server = ''
        self.node_name = socket.getfqdn()
        self.filter = '*:*'
    
    def configure(self, conf):
        for node in conf.children:
            if node.key == 'Verbose':
                self.verbose = bool(node.values[0])
            elif node.key == 'Server':
                self.server = node.values[0]
            elif node.key == 'Node':
                self.node_name = node.values[0]

    def nodes(self):
        data = self.knife('search', 'node', self.filter)
        return [ChefNode(row) for row in data['rows']]

    def knife(self, *args):
        cmd = ['knife']+list(args)+['-u', self.node_name, '-s', self.server]
        collectd.debug('Running %s'%(' '.join(cmd)))
        p = subprocess.Popen(cmd, stdout=subprocess.PIPE)
        out, err = p.communicate()
        lines = out.splitlines()
        if lines[0] == 'No knife configuration file found':
            del lines[0]
        out = ''.join(lines)
        try:
            return json.loads(out)
        except ValueError:
            collectd.error('Unable to decode %r'%out)

# Host to connect to. Override in config by specifying 'Host'.
REDIS_HOST = 'localhost'

# Port to connect on. Override in config by specifying 'Port'.
REDIS_PORT = 6379

# Verbose logging on/off. Override in config by specifying 'Verbose'.
VERBOSE_LOGGING = False


def fetch_info():
    """Connect to Redis server and request info"""
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.connect((REDIS_HOST, REDIS_PORT))
        log_verbose('Connected to Redis at %s:%s' % (REDIS_HOST, REDIS_PORT))
    except socket.error, e:
        collectd.error('redis plugin: Error connecting to %s:%d - %r'
                       % (REDIS_HOST, REDIS_PORT, e))
        return None
    fp = s.makefile('r')
    log_verbose('Sending info command')
    s.sendall('info\n')

    info_data = []
    while True:
        data = fp.readline().strip()
        log_verbose('Received data: %s' % data)
        if data == '':
            break
        if data[0] == '$':
            continue
        info_data.append(data)

    s.close()
    return parse_info(info_data)


def parse_info(info_lines):
    """Parse info response from Redis"""
    info = {}
    for line in info_lines:
        if ':' not in line:
            collectd.warning('redis plugin: Bad format for info line: %s'
                             % line)
            continue

        key, val = line.split(':')

        # Handle multi-value keys (for dbs).
        # db lines look like "db0:keys=10,expire=0"
        if ',' in val:
            split_val = val.split(',')
            val = {}
            for sub_val in split_val:
                k, v = sub_val.split('=')
                val[k] = v

        info[key] = val
    return info


def configure_callback(conf):
    """Receive configuration block"""
    global REDIS_HOST, REDIS_PORT, VERBOSE_LOGGING
    for node in conf.children:
        if node.key == 'Host':
            REDIS_HOST = node.values[0]
        elif node.key == 'Port':
            REDIS_PORT = int(node.values[0])
        elif node.key == 'Verbose':
            VERBOSE_LOGGING = bool(node.values[0])
        else:
            collectd.warning('redis plugin: Unknown config key: %s.'
                             % node.key)
    log_verbose('Configured with host=%s, port=%s' % (REDIS_HOST, REDIS_PORT))


def dispatch_value(info, key, type, type_instance=None):
    """Read a key from info response data and dispatch a value"""
    if key not in info:
        collectd.warning('redis plugin: Info key not found: %s' % key)
        return

    if not type_instance:
        type_instance = key

    value = int(info[key])
    log_verbose('Sending value: %s=%s' % (type_instance, value))

    val = collectd.Values(plugin='redis')
    val.type = type
    val.type_instance = type_instance
    val.values = [value]
    val.dispatch()


def read_callback():
    log_verbose('Read callback called')
    info = fetch_info()

    if not info:
        collectd.error('redis plugin: No info received')
        return

    # send high-level values
    dispatch_value(info, 'total_commands_processed', 'counter',
                   'commands_processed')
    dispatch_value(info, 'connected_clients', 'gauge')
    dispatch_value(info, 'used_memory', 'bytes')

    # database stats
    for key in info:
        if key.startswith('db'):
            dispatch_value(info[key], 'keys', 'gauge', '%s-keys' % key)


def log_verbose(msg):
    if not VERBOSE_LOGGING:
        return
    collectd.info('redis plugin [verbose]: %s' % msg)


# register callbacks
#collectd.register_config(configure_callback)
#collectd.register_read(read_callback)

plugin = ChefPlugin()
collectd.register_config(plugin.configure)

if __name__ == '__main__':
    collectd.main({'Server': 'http://risk-chef:4000/', 'Node': 'nkantrowitz'})
    from pprint import pprint
    nodes = plugin.nodes()
    for n in nodes:
        pprint(n.attributes)
