#!/bin/bash

# 資料夾路徑
folder_path_iseq="/Users/mei/Desktop/MRSA/Fastq"
folder_path_ONT="/Users/mei/Desktop/MRSA/raw_cat"

# 輸出目錄
output_dir="unicycler_output"

# 迴圈處理檔案
for i in {1..12}
do
  # 構建 R1 和 R2 檔案路徑
  r1_file=""
  r2_file=""

  for file in "${folder_path_iseq}/"*"${i}_L001_R1_001"*
  do
    if [[ $file == *"${i}_L001_R1_001"* ]]; then
      r1_file=$file
      break
    fi
  done

  for file in "${folder_path_iseq}/"*"${i}_L001_R2_001"*
  do
    if [[ $file == *"${i}_L001_R2_001"* ]]; then
      r2_file=$file
      break
    fi
  done
  # 構建輸入檔案路徑
  input_file="${folder_path_ONT}/barcode$(printf "%02d" $i).fastq"

  # 構建輸出目錄路徑
  output_subdir="${output_dir}/barcode$(printf "%02d" $i)"

  # 判斷是否找到 R1 和 R2 檔案
  if [ -n "$r1_file" ] && [ -n "$r2_file" ]; then
    # 找到 R1 和 R2 檔案，執行 unicycler 指令
    unicycler -1 "$r1_file" -2 "$r2_file" -l "$input_file" -o "$output_subdir"
  else
    # 未找到 R1 或 R2 檔案，或是兩者只有其一
    # 在輸出資料夾中創建一個文字檔，紀錄未使用的檔案名稱
    unused_file="$output_subdir/unused_files.txt"
    echo "R1 File: $r1_file" > "$unused_file"
    echo "R2 File: $r2_file" >> "$unused_file"
  fi
done
