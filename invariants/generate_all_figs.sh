for d in $1*.ini;
do
	python ~/Workspace/scripts/invariants/plot_invariant.py -cp $d
	python ~/Workspace/scripts/invariants/plot_intervals.py -cp $d
        python ~/Workspace/scripts/invariants/plot_pairplot.py -cp $d
done
