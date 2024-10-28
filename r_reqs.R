# Function to generate requirements
generate_requirements <- function(path = ".", output_file = "requirements.txt") {
  # List all R files in the specified directory and its subdirectories
  files <- list.files(
    path,
    pattern = "\\.R$",
    full.names = TRUE,
    recursive = TRUE
  )

  # Initialize an empty vector to store package names
  packages <- character()

  # Loop through each file and extract package names
  inside_multi_line_comment <- FALSE
  for (file in files) {
    lines <- readLines(file, warn = FALSE)

    # Create an combine regex patterns
    ignore_comments <- "#.*"
    ignore_multiline_comments <- '"""'

    lines_without_comments <- gsub(ignore_comments, "", lines)

    quote_positions <- lines_without_comments == ignore_multiline_comments

    # Odd cumsum values indicate we're inside a block, even means outside
    inside_comment <- cumsum(quote_positions) %% 2 == 1

    cleaned_lines <- lines_without_comments[!inside_comment]

    match_library <- "(?<=library\\()(\\w+)"
    match_require <- "(?<=require\\()(\\w+)"
    match_direct_reference <- "(\\w+)(?=::)"
    regex_pattern <- sprintf(
      "%s|%s|%s",
      match_library,
      match_require,
      match_direct_reference
    )

    # Extract library and require calls
    matches <- gregexec(
      regex_pattern,
      cleaned_lines,
      perl = TRUE
    )

    libs <- regmatches(cleaned_lines, matches)

    # Flatten the list and remove NULLs
    libs <- unlist(libs)
    libs <- libs[libs != ""]
    
    # Append unique packages to the vector
    packages <- unique(c(packages, libs))
  }
  
  # Write packages to the output file
  if (length(packages) > 0) {
    writeLines(paste0("install.packages(\"", packages, "\")"), output_file)
    message("Requirements written to ", output_file)
  } else {
    message("No packages found.")
  }
}

# Get command-line arguments
args <- commandArgs(trailingOnly = TRUE)

# Check if a path argument is provided
if (length(args) > 0) {
  path <- args[1]
} else {
  path <- "."
}

# Run the function with the specified or default path
generate_requirements(path)