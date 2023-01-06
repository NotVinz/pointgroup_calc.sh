#!/bin/sh
# Returns the point group of your molecule(s) in space-separated format
# both for all atoms and for all atoms except H.
# You may (might) want to add this script to your .bashrc file :)

if [ "$#" -eq "0" ]; then
echo "Invalid number of arguments"
echo "At least one molecular file must be specified."
echo " ! Some valid examples:"
echo " ! $0 filename.xyz"
echo " ! $0 *.xyz"
exit
fi

cat <<EOF >>jmol_PG_script.spt
pg_var=pointgroup(all);
all_pg=pg_var.name;
sel_atoms=pg_var.detail
report=[sel_atoms[3][-1] all_pg ]
write var report all_pg.txt

all_pg=pointgroup({!_H}).name;
sel_atoms=pointgroup({!_H}).detail
report=[sel_atoms[3][-1] all_pg ]
write var report NOH_pg.txt
EOF

echo molfile all_atoms not_H
for molfile in "$@"
do
    jmol -load $molfile -n -s jmol_PG_script.spt >/dev/null 
    allatoms=$(tail -1 all_pg.txt)
    notH=$(tail -1 NOH_pg.txt)
    echo "$molfile $allatoms $notH"
done

rm -f jmol_PG_script.spt
rm -f all_pg.txt
rm -f NOH_pg.txt
