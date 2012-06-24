config_cbs = []

def register_config(cb):
    config_cbs.append(cb)

class Node(object):
    def __init__(self, key, values):
        self.key = key
        self.values = values

class Config(object):
    def __init__(self, options):
        self.children = [Node(key, [value]) for key, value in options.iteritems()]

def main(options):
    conf = Config(options)
    for cb in config_cbs:
        cb(conf)

def error(msg):
    print msg

debug = error
