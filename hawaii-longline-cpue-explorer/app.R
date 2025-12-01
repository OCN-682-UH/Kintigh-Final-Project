# Purpose: The purpose of this project is to build an interactive Shiny application that visualizes how environmental conditions shape multispecies CPUE patterns in the Hawaiʻi longline fishery.

# Created by: Isabella Kintigh
# Created on: 19 November 2025

# Multi-species Bigeye/Billfish CPUE Explorer
#--------------------------------------------------

library(shiny)
library(tidyverse)
library(viridis)
library(lubridate)
library(bslib)


# --------- Load binned, cleaned longline data (all species) --------------

LL_Data_df <- readRDS("Data/LL_Data_Binned.rds")


# ----------- Environmental variable choices (UI label -> column) -------------

env_var_choices <- c(
  "SST" = "sst",
  "SSS" = "sss",
  "SSH" = "ssh",
  "Mixed Layer Depth" = "mld",
  "Chlorophyll-a" = "chl_cop",
  "Zonal Current (U)" = "u",
  "Meridional Current (V)" = "v",
  "Current Speed" = "current_speed",
  "Rugosity" = "rugosity",
  "Lunar Radiation" = "lunar_rad",
  "SST SD" = "sst_sd",
  "SSS SD" = "sss_sd",
  "SSH SD" = "ssh_sd",
  "Oxygen 300 m" = "oxy300",
  "Oxygen 150 m" = "oxy150",
  "Temperature 300 m" = "temp300",
  "Temperature 150 m" = "temp150",
  "Sea Level Anomaly" = "sla",
  "Subsurface O2" = "o2"
)

# ------------------------- Species images ---------------------------------

species_images <- c(
  "Thunnus obesus" = "bigeye.png",
  "Makaira nigricans" = "blue.png",
  "Kajikia audax" = "striped.png",
  "Istiophorus platypterus" = "sailfish.png",
  "Tetrapturus angustirostris" = "hebi.png",
  "Xiphias gladius" = "swordfish.png"
)

# -------------- Species choices (all species in the dataset) -----------------
species_choices <- sort(unique(LL_Data_df$species))

#
# ----------------------------------- UI -------------------------------------

ui <- fluidPage(
  theme = bs_theme(
    version = 3, # use Bootstrap 5
    bootswatch = "readable" # apply readable theme
  ),
  
  # adding my name
  div(
    style = "text-align:right; color:#555; font-size:14px; margin-top:-0px; margin-bottom:10px;",
    "Created by Isabella Kintigh"
  ),
  
  titlePanel("CPUE Explorer for Hawaiʻi Longline Species"), # title
  sidebarLayout( # sidebar
    sidebarPanel( 
      width = 3,
      
      # Species drop down to allow multi-species selection
      selectInput(
        inputId = "species_select",
        label = "Select species:",
        choices = species_choices,
        selected = "Thunnus obesus" # drop down default 
      ),
      
      # Show species image under the dropdown
      uiOutput("species_image"),
      
      # Year drop down to choose which year to visualize
      selectInput(
        inputId = "env_map_year",
        label = "Select Year:",
        choices = sort(unique(LL_Data_df$year)),
        selected = min(LL_Data_df$year, na.rm = TRUE)
      ),
      
      # Optional month selector
      selectInput(
        inputId = "env_map_month",
        label = "Select Month (optional):",
        choices = c("All", levels(LL_Data_df$month)),
        selected = "All"
      )
    ), # end of side bar panel 
    
    # main panel where all the tab contents appear 
    mainPanel(
      width = 9,
      tabsetPanel(
        id = "tabs",
        
        # --------- TAB 1: Spatial Environmental Map + CPUE Map ------==---
        
        tabPanel(
          title = "Spatial Env Map",
          br(), # spacing
          fluidRow(
            column(
              width = 6,
              selectInput(
                inputId = "env_map_var",
                label = "Environmental variable for map:",
                choices = env_var_choices, # env drop down
                selected = "sst" # drop down default
              )
            )
          ),
          br(), # spacing
          
          # create two side-by-side maps for easy cpue to env comparison
          fluidRow(
            column(
              width = 6,
              plotOutput("env_tile_map", height = "500px")
            ),
            column(
              width = 6,
              plotOutput("cpue_tile_map", height = "500px")
            )
          )
        ), # end of tab 1
        
        # --------------- TAB 2: CPUE vs Environmental Variable ---------------
        # explore functional relationships between CPUE and a chosen environmental variable
        
        tabPanel(
          title = "CPUE vs Environment",
          br(), # spacing
          
          # row for environmental variable selector
          fluidRow(
            column(
              width = 6,
              selectInput(
                inputId = "env_var_cpue",
                label = "Select environmental variable:",
                choices = env_var_choices, # drop down for choosing variable
                selected = "sst" # default selection
              )
            )
          ),
          
          # output plot for CPUE vs env variable
          plotOutput("cpue_env_plot", height = "550px")
          
        ), # end of tab 2
        
        # -------------- TAB 3: Env × Env → CPUE Heatmap ----------------------
        
        tabPanel(
          title = "Env × Env → CPUE",
          br(), # add spacing
          fluidRow(
            column(
              width = 6,
              selectInput(
                inputId = "env_x",
                label = "X-axis environmental variable:",
                choices = env_var_choices, # env drop down
                selected = "sst" # drop down default
              )
            ),
            column(
              width = 6,
              selectInput(
                inputId = "env_y",
                label = "Y-axis environmental variable:",
                choices = env_var_choices,
                selected = "ssh" # drop down default
              )
            )
          ),
          plotOutput("env_env_heatmap", height = "550px")
        ), # end of tab 3
        
        # --------------- TAB 4: Year × Month CPUE Heatmap --------------------
        # simple output to look at CPUE over time and by month
        
        tabPanel(
          title = "Year × Month CPUE",
          br(), # spacing
          plotOutput("year_month_heatmap", height = "550px")
        ) # end of tab 4
      ) # end of tabset panel
    ) # end of main panel
  ) # end of sidebar layout 
) # end of UI


# --------------------------- SERVER -----------------------------------

server <- function(input, output, session) {
  
  # Create a reactive dataset filtered by species, year, and month (optional)

  filtered_df <- reactive({
    # Start with full longline dataset
    
    df <- LL_Data_df %>%
      
      filter( # Keep only rows for the selected species
        species == input$species_select,
        year == input$env_map_year # Keep only rows for the selected year
      )
    
    # Apply month filter if user chose a specific month
    if (input$env_map_month != "All") {
      df <- df %>% filter(month == input$env_map_month)
    }
    # Return filtered dataset
    df
  })
  
  # Render species image under dropdown
  output$species_image <- renderUI({
    req(input$species_select)
    
    img_file <- species_images[[input$species_select]]
    
    tags$img(
      src = img_file,
      width = "100%",
      style = "border-radius: 8px; margin-top: 10px;"
    )
  })
  

  # --------------- OUTPUT 1 LEFT: Environmental Tile Map ----------------------

  output$env_tile_map <- renderPlot({
    df <- filtered_df() # Retrieve filtered dataset
    env_col <- input$env_map_var # Identify selected environmental variable
    
    # Create pretty label for legend
    env_label <- names(env_var_choices)[env_var_choices == env_col]
    
    # Create tile map of environmental conditions
    ggplot(df, aes(x = lon_bin, y = lat_bin)) +
      geom_tile(
        aes(fill = .data[[env_col]]),
        color = "white",
        linewidth = 0.3
      ) +
      scale_fill_viridis(option = "C", name = env_label) +
      coord_equal() +
      labs(
        title = paste0(
          env_label, " for ", input$species_select, " in ", input$env_map_year,
          ifelse(input$env_map_month == "All", "", paste0(" — ", input$env_map_month))
        ),
        x = "Longitude (5° bins)",
        y = "Latitude (5° bins)"
      ) +
      theme_minimal(base_size = 13) +
      theme(panel.grid = element_blank())
  }) # end of output 1 (left)
  

  # ------------------- OUTPUT 1 RIGHT: CPUE Tile Map ---------------------

  output$cpue_tile_map <- renderPlot({
    df <- filtered_df() # Retrieve filtered dataset
    ggplot(df, aes(x = lon_bin, 
                   y = lat_bin)) +  # Create tile map of CPUE
      geom_tile(
        aes(fill = cpue),
        color = "white",
        linewidth = 0.3
      ) +
      scale_fill_viridis(option = "A", name = "CPUE") +
      coord_equal() +
      labs(
        title = paste0(
          "CPUE for ", input$species_select, " in ", input$env_map_year,
          ifelse(input$env_map_month == "All", "", paste0(" — ", input$env_map_month))
        ),
        x = "Longitude (5° bins)",
        y = "Latitude (5° bins)"
      ) +
      theme_minimal(base_size = 13) +
      theme(panel.grid = element_blank())
  }) # end of output 1 (right)
 
  # ------- OUTPUT 2: Environmental × Environmental → CPUE Heatmap -------------
  
  # Includes midpoint binning for clean numeric axes

  output$env_env_heatmap <- renderPlot({
    
    df <- filtered_df() # Retrieve filtered dataset
    
    # Store selected environmental variables
    x_var <- input$env_x
    y_var <- input$env_y
    
    # Pretty axis labels
    x_label <- names(env_var_choices)[env_var_choices == x_var]
    y_label <- names(env_var_choices)[env_var_choices == y_var]
    
    # Bin environmental variables into 12 categories for easy visualization
    df_bins <- df %>%
      mutate(
        x_bin = cut(.data[[x_var]], breaks = 12, include.lowest = TRUE),
        y_bin = cut(.data[[y_var]], breaks = 12, include.lowest = TRUE)
      )
    
    # Extract midpoints from bin boundaries
    df_bins <- df_bins %>%
      mutate(
        x_low  = as.numeric(sub("\\((.+),.*", "\\1", x_bin)),
        x_high = as.numeric(sub(".*,(.+)\\]", "\\1", x_bin)),
        x_mid  = (x_low + x_high) / 2,
        y_low  = as.numeric(sub("\\((.+),.*", "\\1", y_bin)),
        y_high = as.numeric(sub(".*,(.+)\\]", "\\1", y_bin)),
        y_mid  = (y_low + y_high) / 2
      )
    
    # Compute average CPUE per environmental midpoint cell
    df_heat <- df_bins %>%
      group_by(x_mid, y_mid) %>%
      summarise(mean_cpue = mean(cpue, na.rm = TRUE), .groups = "drop")
    
    # Plot heatmap with midpoints on axes
    ggplot(df_heat, aes(x = x_mid, y = y_mid, fill = mean_cpue)) +
      geom_tile(color = "white", linewidth = 0.25) +
      scale_fill_viridis(option = "A", name = "Mean CPUE") +
      labs(
        title = paste0("CPUE Surface for ", input$species_select, ": ", x_label, " vs ", y_label),
        x = x_label,
        y = y_label
      ) +
      theme_minimal(base_size = 13) +
      theme(
        axis.text.x = element_text(angle = 45, hjust = 1),
        panel.grid = element_blank()
      )
  }) # end of output 2
  
  # ---------------- OUTPUT 3: Year × Month CPUE Heatmap ---------------------
  # Uses all years for the selected species to make a cpue heatmap 

  output$year_month_heatmap <- renderPlot({
    # Filter dataset by selected species only
    df <- LL_Data_df %>%
      filter(species == input$species_select) %>%
      group_by(year, month) %>%
      summarise(mean_cpue = mean(cpue, na.rm = TRUE), .groups = "drop")
    
    # Plot heatmap of year × month
    ggplot(
      df,
      aes(
        x = factor(year),
        y = factor(month, levels = month.abb),
        fill = mean_cpue
      )
    ) +
      geom_tile(color = "white", linewidth = 0.3) +
      scale_fill_viridis(option = "A", name = "Mean CPUE") +
      labs(
        title = paste0("Mean CPUE by Year and Month for ", input$species_select),
        x = "Year",
        y = "Month"
      ) +
      theme_minimal(base_size = 13) +
      theme(
        axis.text.x = element_text(angle = 45, hjust = 1),
        panel.grid = element_blank()
      )
  }) # end of output 3
  
  # -------------- OUTPUT 4: CPUE vs Environmental Variable --------------------
  # creates a scatterplot with a GAM smooth to show CPUE response to an environmental variable
  
  output$cpue_env_plot <- renderPlot({
    
    df <- filtered_df() # retrieve filtered dataset (species + year + optional month)
    
    env_col <- input$env_var_cpue # store selected environmental variable
    
    # pretty label for the chosen environmental variable
    env_label <- names(env_var_choices)[env_var_choices == env_col]
    
    # create scatterplot with GAM smoother to explore functional response
    ggplot(df, aes(x = .data[[env_col]], y = cpue)) +
      geom_point(alpha = 0.3, color = "steelblue") + # semi-transparent points to reduce clutter
      geom_smooth(
        method = "gam",
        formula = y ~ s(x, k = 10),
        color = "white",
        fill = "gray40",
        linewidth = 1
      ) +
      labs(
        title = paste0("CPUE vs ", env_label, " for ", input$species_select),
        x = env_label,
        y = "CPUE"
      ) +
      theme_minimal(base_size = 13) +
      theme(
        panel.grid = element_blank()
      )
  })
  
} # End of server function

#--------------------------------------------------
# Run app
#--------------------------------------------------
shinyApp(ui = ui, server = server)