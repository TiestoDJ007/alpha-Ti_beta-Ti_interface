#!/usr/bin/env bash
source /PARA/app/scripts/cn-module.sh
source /PARA/app/other/vasp.5.4.4/vasp-module.sh
module load vasp/5.4.4-mpi3-O3-scalapack-vtst
echo > structure_energy
for Number_dir in `seq 1 1 20`
do
DISTANCE=$(printf "%.3f" `echo "scale=2;$Number_dir*(0.5)"|bc`)
echo "Distance=$DISTANCE"
cp {INCAR,KPOINTS,POTCAR} $Number_dir/
cd $Number_dir
cp POSCAR_alpha.vasp POSCAR
srun -N 1 -n 24 -p paratera -J dilute-Ti vasp_std
E_alpha=`grep "TOTEN" OUTCAR | tail -1|awk '{printf"%12.6f \n",$5}'`
cp POSCAR_beta.vasp POSCAR
srun -N 1 -n 24 -p paratera -J dilute-Ti vasp_std
E_beta=`grep "TOTEN" OUTCAR | tail -1|awk '{printf"%12.6f \n",$5}'`
cp POSCAR_total.vasp POSCAR
srun -N 1 -n 24 -p paratera -J dilute-Ti vasp_std
E_total=`grep "TOTEN" OUTCAR | tail -1|awk '{printf"%12.6f \n",$5}'`
W_seq=$(printf "%.6f" `echo "scale=2;$E_total-$E_alpha-$E_beta"|bc`)
cd ..
echo -e "DISTANCE=$DISTANCE\nE_alpha=$E_alpha E_beta=$E_beta E_total=$E_total\nW_seq=$W_seq\n" >> structure_energy
done
cat structure_energy