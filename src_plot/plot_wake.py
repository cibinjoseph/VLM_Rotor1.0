OpenDatabase("Results/Fwake*.tec database")
AddPlot("Mesh", "mesh", 1, 1)
DrawPlots()
OpenDatabase("Results/Nwake*.tec database")
CreateDatabaseCorrelation("Wake",("/home/cibin/WorkInProgress/VOLCANOR/Results/Fwake*.tec database", "/home/cibin/WorkInProgress/VOLCANOR/Results/Nwake*.tec database"), 0)
AddPlot("Mesh", "mesh", 1, 1)
DrawPlots()
