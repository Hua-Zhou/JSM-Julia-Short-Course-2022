using Pluto, Pkg
notebookdir = "JSM-Julia-Short-Course-2022/notebooks/"
filelist = readdir(notebookdir)
for file in filelist
    if endswith(file, ".jl")
        Pluto.activate_notebook_environment(notebookdir * file)
        Pkg.instantiate()
    end 
end
