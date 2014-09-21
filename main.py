import sys
import os
from generator import Generator
from table import Table


if len(sys.argv) != 3:
    print(
        'Usage: {0} "input.file" "output.file"'
        .format(os.path.basename(__file__)))
    sys.exit()

gen = Generator(sys.argv[1], sys.argv[2])
gen.save_statements()
