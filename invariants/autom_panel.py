import glob
import os


paths = glob.glob('/home/agarpe/Workspace/tesis/PhD.-thesis-Alicia-Garrido-Pe-a/invariants/data/SUSSEX/*/images/')

print(paths)


headers = '''\\documentclass{article}
\\usepackage{graphicx}
\\usepackage{overpic}

\\usepackage[left=0.7in,right=0.7in,top=0.1in]{geometry}


\\begin{document}\n'''

figure = '''    \\begin{figure}[htbp]
        \\centering
        \\begin{minipage}[b]{\\textwidth}
            \\centering
            \\includegraphics[width=\\textwidth,height=0.1\\textheight]{_signal_intervals_zoom.pdf}
            \\includegraphics[width=\\textwidth]{_signal_intervals_cycle.pdf}
            \\includegraphics[width=\\textwidth]{_time_cycle.pdf}
        \\end{minipage}
        \\centering
        \\begin{minipage}[b]{\\textwidth}
            \\begin{minipage}[b]{0.45\\textwidth}
                \\centering
                \\includegraphics[width=\\textwidth]{_boxplot.pdf}
            \\end{minipage}
            \\begin{minipage}[b]{0.53\\textwidth}
                \\centering
                \\begin{minipage}[b]{\\textwidth}
                    \\centering
                    \\includegraphics[width=\\textwidth]{_durations.pdf}
                \\end{minipage}\\
                \\begin{minipage}[b]{\\textwidth}
                    \\centering
                    \\includegraphics[width=\\textwidth]{_intervals.pdf}
                \\end{minipage}\\
                \\begin{minipage}[b]{\\textwidth}
                    \\centering
                    \\includegraphics[width=\\textwidth]{_delays.pdf}
                \\end{minipage}
            \\end{minipage}
        \\end{minipage}
    \\end{figure}
\
\\end{document}'''


def create_file(path):
    print("Creating file ", path+"panel_with_intervals.tex")
    file_name = path+'panel_with_intervals.tex'
    with open(file_name,'w') as file:
        file.write(headers)
        file.write("\\graphicspath{ { %s } }\n"%path)
        file.write(figure)

    # print('pdflatex -synctex=interaction=nonstopmode %s'%file_name)
    os.system('cd %s'%path)
    os.chdir(path)
    os.system('pwd')
    os.system('pdflatex -interaction=nonstopmode panel_with_intervals.tex')
    os.system('rm panel_with_intervals.log panel_with_intervals.aux')
    os.system('pdfcrop panel_with_intervals.pdf panel_with_intervals.pdf')

for path in paths:
    inner_paths = glob.glob(path+'/*/')
    if len(inner_paths) > 0:
        for inner_path in inner_paths:
            create_file(inner_path)
    else:
        create_file(path)
