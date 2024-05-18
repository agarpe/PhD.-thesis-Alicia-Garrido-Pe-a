for d in *.ini;
do
	python ~/Workspace/scripts/invariants/plot_invariant.py -cp $d
	python ~/Workspace/scripts/invariants/plot_intervals.py -cp $d

done
