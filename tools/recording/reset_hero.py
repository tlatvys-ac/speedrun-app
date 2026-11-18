import json, uuid, os, shutil
base = '/tmp/srtest/demo/hero'
src = json.load(open('/tmp/srtest/e2e2/Town Hall.speedrun/project.json'))
p = dict(src)
for a in p['assets']:
    for k in ('defaultColor', 'markers', 'markIn', 'markOut'): a.pop(k, None)
    if a.get('playablePath'): a['playablePath'] = a['playablePath'].replace('/tmp/srtest/e2e2/', base + '/')
for t in p['tracks']: t['clips'] = []
p['markers'] = []; p['syncGroups'] = []; p['transcripts'] = []; p['closedSequences'] = []
foot, gfx = str(uuid.uuid4()).upper(), str(uuid.uuid4()).upper()
p['bins'] = [{'id': foot, 'name': 'Footage', 'expanded': True}, {'id': gfx, 'name': 'Graphics', 'expanded': True}]
for a in p['assets']: a['binId'] = gfx if 'L3' in a['name'] else foot
d = base + '/Town Hall.speedrun'
for f in os.listdir(d): os.remove(os.path.join(d, f))
json.dump(p, open(d + '/project.json', 'w'), indent=1)
md = base + '/Town Hall Media'
for f in os.listdir(md):
    if not f.startswith('Scott Stroud_L3_V5'): 
        q = os.path.join(md, f); shutil.rmtree(q) if os.path.isdir(q) else os.remove(q)
print(os.listdir(d), os.listdir(md))
