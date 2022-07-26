# Julia for Data Science and Statistical Computing

This repo contains the materials for the short course [Julia for Data Science and Statistical Computing](https://ww2.amstat.org/meetings/jsm/2022/onlineprogram/ActivityDetails.cfm?SessionID=223492) at 2022 Joint Statistical Meeting (JSM), Washington, DC, United States on August 9, 2022.

## Instructors

* Josh Day, Senior Research Scientist, Julia Computing

* Hua Zhou, Professor of Biostatistics, UCLA

## Syllabus

### Module 1: Julia for Data Science I, 8:30am-10:15am

| Time | Topic | Presenter |
|:-----------|:------------|:------------|
| 8:30-9:00 | Introduction \[[html](https://joshday.github.io/hosted_html/01-intro.jl.html)\] | Dr. Josh Day |
| 9:00-9:30 | Pluto & Plotting \[[html](https://joshday.github.io/hosted_html/02-pluto+plotting.jl.html)\] | Dr. Josh Day |
| 9:30-10:00 | DataFrames \[[html](https://joshday.github.io/hosted_html/03-dataframes.jl.html)\] | Dr. Josh Day |
| 10:00-10:15 | Q&A, exercises | Participants |

### Mid-morning break: 10:15am-10:30am

### Module 2: Julia for Data Science II, 10:30am-12:30pm

| Time | Topic | Presenter |
|:-----------|:------------|:------------|
| 10:30-11:00 | Statistical Modeling \[[html](https://joshday.github.io/hosted_html/04-statsmodels.jl.html)\] | Dr. Josh Day |
| 11:00-11:30 | Big Data \[[html](https://joshday.github.io/hosted_html/05a-onlinestats.jl.html)\] | Dr. Josh Day |
| 11:30-12:15 | R vs Python vs Julia vs C/C++ \[[html](https://hua-zhou.github.io/JSM-Julia-Short-Course-2022/notebooks/06-langs/06-langs.html)\] | Dr. Hua Zhou |
| 12:15-12:30 | Q&A, exercises | Participants |

### Lunch break: 12:30pm-2:00pm

### Module 3: Julia for Statistical Computing I, 2:00pm-3:15pm

| Time | Topic | Presenter |
|:-----------|:------------|:------------|
| 2:00-2:30 | Numerical linear algebra: BLAS/LAPACK \[[html](https://hua-zhou.github.io/JSM-Julia-Short-Course-2022/notebooks/07-numlinalg/07-numlinalg.html)\] | Dr. Hua Zhou |
| 2:30-3:00 | Numerical linear algebra: iterative algorithms \[[html](https://hua-zhou.github.io/JSM-Julia-Short-Course-2022/notebooks/08-iter/08-cg.html)\] | Dr. Hua Zhou |
| 3:00-3:15 | Q&A, exercises | Participants |

### Mid-afternoon break: 3:15pm-3:30pm

### Module 4: Julia for Statistical Computing II, 3:30pm-5:00pm

| Time | Topic | Presenter |
|:-----------|:------------|:------------|
| 3:30-4:45 | Numerical Optimization \[[html](https://hua-zhou.github.io/JSM-Julia-Short-Course-2022/notebooks/09-opt/09-juliaopt.html)\] | Dr. Hua Zhou |
| 4:45-5:00 | Q&A, exercises | Participants |

## Course server

We provide a server where you can run tutorials (Pluto or Jupyter notebooks) during the course.

1. Server address: <http://34.150.236.152/> (expired on Aug 17, 2022)

2. **Username** will be same as the email address (before the @, all lower case) you used to register for the workshop. For example, if you registered for the workshop using email `Jane.Bruin@ucla.edu`, then your username on the server will be `jane.bruin`. **Password** is announced during the workshop.

### Tips

1. Anytime during the workshop, feel free to ask for help.

    Course assistants:
    - Dr. Josh Day
    - Dr. Seyoon Ko (remote)
    - Dr. Hua Zhou
    - Xinkai Zhou

2. In JupyterLab, avoid running many kernels at the same time. Promptly shut down the kernels you don't use.

3. If your kernel dies, most likely you have used more resource than allocated (2 CPU core and 3.6 GB memory). Make sure that you shut down the kernels not in use and try again. Remember that running the tutorials is optional. You can always read the static slides if the server is not responding. We plan to make the workshop materials available to you after the workshop, so you can try again later.

## Run Jupyter/Pluto notebooks on your own laptop

This is **not** recommended during this short course, since your software environment (OS, Julia version, package versions, etc.) may be quite different from that assumed by the Jupyter notebooks. You are certainly welcome to run Jupyter notebooks on your own machine after the workshop, simply `git clone https://github.com/Hua-Zhou/JSM-Julia-Short-Course-2022.git` to sync the most recent course materials to your computer and install all needed Julia packages.
