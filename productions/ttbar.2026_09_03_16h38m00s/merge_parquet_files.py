"""
Given a directory, merge all parquet files inside the directory
on the assumption that they have the same schema.

Parquet files are originally written with awkward.to_parquet(ret_record, ofn)
"""
import argparse
import os
import pyarrow.parquet as pq
import pyarrow as pa

def main():
    args = options()
    merge_parquet_files(args.directory, args.output_file)


def options():
    parser = argparse.ArgumentParser(description="Merge all parquet files in a directory into a single parquet file")
    parser.add_argument("directory", help="Directory containing parquet files")
    parser.add_argument("output_file", help="Output parquet file")
    return parser.parse_args()


def merge_parquet_files(directory, output_file):
    print(f"Listing parquet files ...")
    parquet_files = [os.path.join(directory, f) for f in os.listdir(directory) if f.endswith('.parquet')]
    if not parquet_files:
        raise ValueError("No parquet files found in the directory")

    print(f"Reading {len(parquet_files)} parquet files ...")
    tables = [pq.read_table(f) for f in parquet_files]

    print(f"Concatenating ...")
    combined_table = pa.concat_tables(tables)

    print(f"Writing ...")
    pq.write_table(combined_table, output_file)


if __name__ == "__main__":
    main()

