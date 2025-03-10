Documentation for Eduvos IT Graduates Survey Dashboard

Project Summary

The purpose of this R Shiny dashboard is to analyze and visualize the survey responses of graduates from Eduvos IT. It provides comprehensive analytics about employment patterns, web frameworks, databases, programming languages, and platforms utilized amongst the graduates.

Technologies Used
- Web application development was done using R Shiny.
- ggplot2 & Plotly were utilized for interactive data visualization
- dplyr & tidyr for data processing
- Interactive data tables were created using DT
- UI improvements were made using Shinythemes

Notable Features
1. Processed Data – Contains the processed survey dataset.
2. Most Frequently Used Tech Tools – Displays the most frequently utilized programming languages, databases, platforms, and frameworks. Filters enabled.
3. Graduates Employment Sectors – Displays the industries entered by graduates classified by branch of study.
4. Employment Statistics – Employment statistics of graduates in IT, Data Science, and Computer Science and information presented.



Steps for Processing Data
- Chose the relevant columns needed in the analysis. 
- Set missing known values to “Unknown.”
- Categorical values (e.g. campus names) were made uniform.
- Responses were filtered to the top five campuses that received the most responses.

2. Data Transformation
- Responses in categorical fields were split (for example, several programming languages were selected for each respondent).
- Categorical variables were converted to factors for simpler graphing.
- Count and sort frequency of occurrences for pattern detection.

Delivery and Deployment
- An application is currently running on Shinyapps.io: https://qb9jxb6t6.shinyapps.io/assignment/
- The application code can be located in the provided following GitHub link: https://github.com/MarcusNaidoo94/assignment_RShinyDashboard 

Problem-Solving Findings
- To troubleshoot graphs that do not load, a page refresh should do the trick. 
- Some visualizations have longer loading times due to the size of the datasets.
- In case of any outstanding issues, please consult the developer.

Contact Information
For questions or problems that need fixes, please contact via GitHub Issues on the repository site.
