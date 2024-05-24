import glob
import os


paths = glob.glob('/home/agarpe/Workspace/tesis/PhD.-thesis-Alicia-Garrido-Pe-a/invariants/data/SUSSEX/*/images/')

print(paths)


headers = '''\\documentclass{article}
\\usepackage{graphicx}
\\usepackage{overpic}

\\usepackage[left=0.7in,right=0.7in,top=0.1in]{geometry}
\\pagenumbering{gobble}

\\begin{document}\n'''

figure = '''\\begin{figure}[htbp]
   \\centering
   \\begin{minipage}{\\textwidth}
       \\centering
       \\begin{overpic}[width=\\textwidth]{_output_pairplot.png} % Base image
           \\put(50,55){ % Position the second image (70%, 60% of width/height of figure1)
               \\includegraphics[width=0.4\\textwidth]{_signal_intervals_cycle_stretch.pdf} % The overlapping image
           }
       \\end{overpic}
   \\end{minipage}
\\end{figure}
\\end{document}
'''

# figure = '''\\begin{figure}[htbp]
#    \\raggedleft
#    \\begin{minipage}[b]{0.85\\textwidth}
#        \\raggedleft
#        \\includegraphics[width=\\textwidth]{_time_cycle.pdf}
#        \\raggedleft
#        \\includegraphics[width=\\textwidth]{_boxplot_h.pdf}     
#    \\end{minipage}
#    \\centering
#    \\begin{minipage}{\\textwidth}
#        \\centering
#        \\begin{overpic}[width=\\textwidth]{_output_pairplot.png} % Base image
#            \\put(50,55){ % Position the second image (70%, 60% of width/height of figure1)
#                \\includegraphics[width=0.4\\textwidth]{_signal_intervals_cycle_stretch.pdf} % The overlapping image
#            }
#        \\end{overpic}
#    \\end{minipage}
# \\end{figure}
# \\end{document}
# '''


def create_file(path):

    print(path)
    print("Creating file ", path+"panel_with_pairplot.tex")
    file_name = path+'panel_with_pairplot.tex'
    with open(file_name,'w') as file:
        file.write(headers)
        file.write("\\graphicspath{ { %s } }\n"%path)
        file.write(figure)

    os.chdir(path)
    os.system('pwd')
    os.system('pdflatex -interaction=nonstopmode panel_with_pairplot.tex')
    os.system('rm panel_with_pairplot.log panel_with_pairplot.aux')
    os.system('pdfcrop panel_with_pairplot.pdf panel_with_pairplot.pdf')

for path in paths:
    inner_paths = glob.glob(path+'/*/')
    if len(inner_paths) > 0:
        for inner_path in inner_paths:
            create_file(inner_path)
    else:
        create_file(path)
