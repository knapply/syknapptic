    library(visNetwork)
    
    nodes <- data.frame(id = 1:10,color = c(rep("blue",6), 
                                            rep("red",3), 
                                            rep("green",1)))
    edges <- data.frame(from = c(1,2,3,3,4,5,6,7,8,9),
                        to = c(2,3,4,8,5,6,7,8,9,10),
                        length = c(2,1,1,1,1,1,1,1,1,1))
    nodes <- data.frame(nodes, level = edges$from)
    
    visNetwork(nodes, edges, 
               # height = "500px", width = "100%",
               main = "Straight Edges") %>% 
      visHierarchicalLayout(edgeMinimization = T,
                            blockShifting = T , 
                            levelSeparation = 89 ) %>%
      visEdges(
        # =========================
               smooth = FALSE, # ========================= straight edges
        # =========================
               shadow = TRUE,
               arrows =list(to = list(enabled = TRUE, scaleFactor = 2)),
               color = list(color = "black", highlight = "red")
        )
