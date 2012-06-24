# This recipe is used to scrub out currently saved
# dashboards allowing repopulation with correct/
# expected final contents

node.set[:gdash][:builtin_dashboards] = {}
