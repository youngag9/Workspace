# Load external data into a data frame.

rm(list = ls())
cat('\f')



# (1) CSV file - read_csv{readr} / read_tsv{readr} / read.csv{utils}
# install.packages('readr', dependencies = TRUE)
library(readr)

( tb_exam <- read_csv("data/csv_exam.csv") )
( tb_exam <- read_csv("data/csv_exam.csv", col_names = TRUE) )
( tb_exam <- read_csv("data/csv_exam.csv", col_names = TRUE, na = "NA") )


( tb_exam <- read_delim(
                "data/csv_exam.csv", 
                ",",                        # if CSV
                # "\t",                     # if TSV
                col_names = T,              # whether column names exists
                quote = "'",                # if quatation mark is a single
                # quote = "\\\"",           # if quotation mark is a double
                escape_backslash = TRUE,    # set ESCAPE CHARACTER
                escape_double = FALSE,
                locale = locale(),          # set locale
                na = "NA",                  # value of missing
                trim_ws = TRUE              # whether trim whitespaces
              )
)
str(tb_exam)



library(readr)

write_csv(tb_exam, 'data/tb_exam.csv')
write_csv(tb_exam, 'data/tb_exam.csv', col_names = F)    # Without column names
write_csv(tb_exam, 'data/tb_exam.csv', col_names = T)    # With column names
write_csv(tb_exam, 'data/tb_exam.csv', col_names = T, append = T)    # With column names, append mode



( df_exam <- read.csv('data/csv_exam.csv') )
( df_exam <- read.csv('data/csv_exam.csv', header = T) )
( df_exam <- read.csv('data/csv_exam.csv', header = T, sep = ',') )
( df_exam <- read.csv('data/csv_exam.csv', header = T, sep = ',', stringsAsFactors = F) )
( df_exam <- read.csv('data/csv_exam.csv', header = T, sep = ',', stringsAsFactors = F, encoding = 'UTF-8') )
( df_exam <- read.csv('data/csv_exam.csv', header = T, sep = ',', stringsAsFactors = F, fileEncoding = 'UTF-8') )
str(df_exam)


write.csv(df_exam, file = 'data/df_exam.csv')
write.csv(df_exam, file = 'data/df_exam.csv', quote = F)
write.csv(df_exam, file = 'data/df_exam.csv', quote = F, sep = ',')
write.csv(df_exam, file = 'data/df_exam.csv', quote = F, sep = ',', append = F)
write.csv(df_exam, file = 'data/df_exam.csv', quote = F, sep = ',', append = F, col.names = T)
write.csv(df_exam, file = 'data/df_exam.csv', quote = F, sep = ',', append = F, col.names = T, row.names = T)
write.csv(df_exam, file = 'data/df_exam.csv', quote = F, sep = ',', append = F, col.names = T, row.names = T, fileEncoding = 'UTF-8')



# (2) Excel file - read_excel{readxl}
# install.packages('readxl', dependencies = TRUE)
library(readxl)

( tb_exam <- read_excel("data/excel_exam.xlsx") )
( tb_exam <- read_excel("data/excel_exam.xlsx", col_names = T) )
( tb_exam <- read_excel("data/excel_exam.xlsx", col_names = T, sheet = 'Sheet1') )
( tb_exam <- read_excel("data/excel_exam.xlsx", col_names = T, sheet = 'Sheet1', range =  'A1:D10') )
( tb_exam <- read_excel("data/excel_exam.xlsx", col_names = T, sheet = 'Sheet1', range =  'A1:D10', na = 'NA') )



# (3) RDA file - only for R
?save       # save{base}
?load       # load{base}

save(df_exam, file = 'data/df_exam.rda')

rm(df_exam)
load(file = 'data/df_exam.rda')



?saveRDS    # saveRDS{base}
?readRDS    # readRDS{base}

saveRDS(tb_exam, file = 'data/tb_exam.rds')

rm(tb_exam)
tb_exam <- readRDS(file = 'data/tb_exam.rds')
