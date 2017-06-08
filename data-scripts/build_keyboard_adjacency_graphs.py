#!/usr/bin/python
import sys
import json

def usage():
    return '''
constructs adjacency_graphs.coffee from QWERTY and DVORAK keyboard layouts

usage:
%s adjacency_graphs.coffee [config]

config - name of json configuration file: data/default, data/cs, data/cs_small ...
The qwerty (US qwerty) and numeric keypad are always included in output file.

''' % sys.argv[0]

AVAILABLE_KEYBOARDS =  {
'qwerty': { 'slanted': True, 'layout': r'''
`~ 1! 2@ 3# 4$ 5% 6^ 7& 8* 9( 0) -_ =+
    qQ wW eE rR tT yY uU iI oO pP [{ ]} \|
     aA sS dD fF gG hH jJ kK lL ;: '"
      zZ xX cC vV bB nN mM ,< .> /?
'''},

'qwertzcs': { 'slanted': True, 'layout': r'''
;° +1 ě2 š3 č4 ř5 ž6 ý7 á8 í9 é0 =% ´ˇ
    qQ wW eE rR tT zZ uU iI oO pP ú/ )(
     aA sS dD fF gG hH jJ kK lL ů" §!
   \| yY xX cC vV bB nN mM ,? .: -_
''' },

'qwertzsk': { 'slanted': True, 'layout': r'''
;° +1 ĺ2 š3 č4 ť5 ž6 ý7 á8 í9 é0 =% ´ˇ
    qQ wW eE rR tT zZ uU iI oO pP ú/ ä( ň)
     aA sS dD fF gG hH jJ kK lL ô" §!
   &* yY xX cC vV bB nN mM ,? .: -_
''' },

'dvorak' : { 'slanted': True, 'layout': r'''
`~ 1! 2@ 3# 4$ 5% 6^ 7& 8* 9( 0) [{ ]}
    '" ,< .> pP yY fF gG cC rR lL /? =+ \|
     aA oO eE uU iI dD hH tT nN sS -_
      ;: qQ jJ kK xX bB mM wW vV zZ
''' },
'keypad': { 'slanted': False, 'layout': r'''
  / * -
7 8 9 +
4 5 6
1 2 3
  0 .
''' },
'mac_keypad': { 'slanted': False, 'layout': r'''
  = / *
7 8 9 -
4 5 6 +
1 2 3
  0 .
''' },
}

DEFAULT_KEYBOARDS = [ 'qwerty', 'dvorak', 'keypad', 'mac_keypad' ]

def get_slanted_adjacent_coords(x, y):
    '''
    returns the six adjacent coordinates on a standard keyboard, where each row is slanted to the
    right from the last. adjacencies are clockwise, starting with key to the left, then two keys
    above, then right key, then two keys below. (that is, only near-diagonal keys are adjacent,
    so g's coordinate is adjacent to those of t,y,b,v, but not those of r,u,n,c.)
    '''
    return [(x-1, y), (x, y-1), (x+1, y-1), (x+1, y), (x, y+1), (x-1, y+1)]

def get_aligned_adjacent_coords(x, y):
    '''
    returns the nine clockwise adjacent coordinates on a keypad, where each row is vert aligned.
    '''
    return [(x-1, y), (x-1, y-1), (x, y-1), (x+1, y-1), (x+1, y), (x+1, y+1), (x, y+1), (x-1, y+1)]

def build_graph(layout_str, slanted):
    '''
    builds an adjacency graph as a dictionary: {character: [adjacent_characters]}.
    adjacent characters occur in a clockwise order.
    for example:
    * on qwerty layout, 'g' maps to ['fF', 'tT', 'yY', 'hH', 'bB', 'vV']
    * on keypad layout, '7' maps to [None, None, None, '=', '8', '5', '4', None]
    '''
    position_table = {} # maps from tuple (x,y) -> characters at that position.
    tokens = layout_str.split()
    token_size = len(tokens[0])
    x_unit = token_size + 1 # x position unit len is token len plus 1 for the following whitespace.
    adjacency_func = get_slanted_adjacent_coords if slanted else get_aligned_adjacent_coords
    assert all(len(token) == token_size for token in tokens), 'token len mismatch:\n ' + layout_str
    for y, line in enumerate(layout_str.split('\n')):
        # the way I illustrated keys above, each qwerty row is indented one space in from the last
        slant = y - 1 if slanted else 0
        for token in line.split():
            x, remainder = divmod(line.index(token) - slant, x_unit)
            assert remainder == 0, 'unexpected x offset for %s in:\n%s' % (token, layout_str)
            position_table[(x,y)] = token

    adjacency_graph = {}
    for (x,y), chars in position_table.items():
        for char in chars:
            adjacency_graph[char] = []
            for coord in adjacency_func(x, y):
                # position in the list indicates direction
                # (for qwerty, 0 is left, 1 is top, 2 is top right, ...)
                # for edge chars like 1 or m, insert None as a placeholder when needed
                # so that each character in the graph has a same-length adjacency list.
                adjacency_graph[char].append(position_table.get(coord, None))
    return adjacency_graph

def read_config(config_file):
    filename = config_file
    if not filename.endswith('.json'):
        filename += '.json'
    try:
        with open(filename) as json_data_file:
            data = json.load(json_data_file)
        if 'keyboards' in data:
            # keyboards 'querty' and 'keypad' are required
            return list(set(data['keyboards'] + ['qwerty', 'keypad']))
        else:
            msg = 'Warning: missing key "keyboards" in config file %s. Using default keyboards.'
            print(msg % (filename))
    except IOError as e:
        msg = 'Warning: cannot read config file %s. Using default keyboards.'
        print(msg % (filename, e.strerror))
    return DEFAULT_KEYBOARDS


if __name__ == '__main__':
    if len(sys.argv) == 3:
        output_file, config_file = sys.argv[1:]
        keyboards = read_config(config_file)
    elif len(sys.argv) == 2:
        output_file = sys.argv[1:]
        keyboards = DEFAULT_KEYBOARDS
    else:
        print(usage())
        sys.exit(0)
    with open(sys.argv[1], 'w') as f:
        f.write('# generated by scripts/build_keyboard_adjacency_graphs.py\n')
        if 'config_file' in locals():
            f.write('#    with config_file ' + config_file + '\n')
        f.write('adjacency_graphs = \n  ')
        lines = []
        for graph_name in sorted(keyboards):
            if graph_name in AVAILABLE_KEYBOARDS:
                graph = build_graph(AVAILABLE_KEYBOARDS[graph_name]['layout'], AVAILABLE_KEYBOARDS[graph_name]['slanted'])
                lines.append('%s: %s' % (graph_name, json.dumps(graph, sort_keys=True)))
            else:
                msg = 'ERROR: missing keyboard "%s" in AVAILABLE_KEYBOARDS'
                print(msg % (graph_name))
        f.write('\n  '.join(lines))
        f.write('\n\n')
        f.write('module.exports = adjacency_graphs\n')
    sys.exit(0)

