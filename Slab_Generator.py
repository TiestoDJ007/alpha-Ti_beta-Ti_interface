from pymatgen.core.surface import SlabGenerator
from pymatgen.ext.matproj import MPRester
from pymatgen.io.vasp.inputs import Poscar
from pymatgen.symmetry.analyzer import SpacegroupAnalyzer

mpr = MPRester('nfXxe0aDBRPSy4sI')
mp_id = "mp-46"
miller_index = [0, 0, 1]
min_slab_size = 8.0
min_vacuum_size = 10.0

if __name__ == "__main__":
    MP_structure = mpr.get_structure_by_material_id(mp_id)
    initial_structure = SpacegroupAnalyzer(MP_structure).get_conventional_standard_structure()
    slabs = SlabGenerator(initial_structure, miller_index=miller_index, min_slab_size=min_slab_size,
                          min_vacuum_size=min_vacuum_size, center_slab=True, lll_reduce=True)
    for number_slab, slab in enumerate(slabs.get_slabs()):
        slab_bak = slab.copy()
        slab.make_supercell([[2, 0, 0],
                             [0, 2, 0],
                             [0, 0, 1]])
        Poscar(slab).write_file('POSCAR_{}_{}'.format(mp_id, number_slab))
