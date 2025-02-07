from icoscp.cpb.dobj import Dobj
from icoscp_core.icos import bootstrap
from icoscp import cpauth
import matplotlib.pyplot as plt
import slugify

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--dobj_list', action='store', type=str, required=True, dest='dobj_list')

arg_parser.add_argument('--param_cpauth_token', action='store', type=str, required=True, dest='param_cpauth_token')
arg_parser.add_argument('--param_variable', action='store', type=str, required=True, dest='param_variable')

args = arg_parser.parse_args()
print(args)

id = args.id

dobj_list = json.loads(args.dobj_list)

param_cpauth_token = args.param_cpauth_token.replace('"','')
param_variable = args.param_variable.replace('"','')




meta, data = bootstrap.fromCookieToken(param_cpauth_token)
cpauth.init_by(data.auth)


plot_files = []
for dobj_pid in dobj_list:
    dobj = Dobj(dobj_pid)
    unit = dobj.variables[dobj.variables.name == param_variable].unit.values[0]
    name = dobj.station['org']['name']
    uri = dobj.station['org']['self']['uri']
    title = f"{name} \n {uri}"
    plot = dobj.data.plot(x='TIMESTAMP', y=param_variable, grid=True, title=title)
    plot.set(ylabel=unit)
    filename = f'/tmp/data/{slugify.slugify(dobj_pid)}.pdf'
    plt.savefig(filename)
    plot_files.append(filename)
    plt.show()

plot_files

file_plot_files = open("/tmp/plot_files_" + id + ".json", "w")
file_plot_files.write(json.dumps(plot_files))
file_plot_files.close()
