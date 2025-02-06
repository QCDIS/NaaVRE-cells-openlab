setwd('/app')
library(optparse)
library(jsonlite)



print('option_list')
option_list = list(

make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--names"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_greeting_template"), action="store", default=NA, type="character", help="my description")
)


opt = parse_args(OptionParser(option_list=option_list))

var_serialization <- function(var){
    if (is.null(var)){
        print("Variable is null")
        exit(1)
    }
    tryCatch(
        {
            var <- fromJSON(var)
            print("Variable deserialized")
            return(var)
        },
        error=function(e) {
            print("Error while deserializing the variable")
            print(var)
            var <- gsub("'", '"', var)
            var <- fromJSON(var)
            print("Variable deserialized")
            return(var)
        },
        warning=function(w) {
            print("Warning while deserializing the variable")
            var <- gsub("'", '"', var)
            var <- fromJSON(var)
            print("Variable deserialized")
            return(var)
        }
    )
}

print("Retrieving id")
var = opt$id
print(var)
var_len = length(var)
print(paste("Variable id has length", var_len))

id <- gsub("\"", "", opt$id)
print("Retrieving names")
var = opt$names
print(var)
var_len = length(var)
print(paste("Variable names has length", var_len))

print("------------------------Running var_serialization for names-----------------------")
print(opt$names)
names = var_serialization(opt$names)
print("---------------------------------------------------------------------------------")

print("Retrieving param_greeting_template")
var = opt$param_greeting_template
print(var)
var_len = length(var)
print(paste("Variable param_greeting_template has length", var_len))

param_greeting_template <- gsub("\"", "", opt$param_greeting_template)


print("Running the cell")
greetings = list()
i = 1
while (i <= length(names)) {
    greetings[[i]] = sprintf(param_greeting_template, names[i])
    i = i + 1
}
# capturing outputs
print('Serialization of greetings')
file <- file(paste0('/tmp/greetings_', id, '.json'))
writeLines(toJSON(greetings, auto_unbox=TRUE), file)
close(file)
