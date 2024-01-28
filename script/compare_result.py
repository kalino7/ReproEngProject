import subprocess

def calculate_md5(file_path):
    """Calculate the MD5 checksum of a file."""
    result = subprocess.run(['md5sum', file_path], capture_output=True, text=True)
    return result.stdout.split()[0]

def compare_schemas():
    original_file = "/home/kali/JSONSchemaDiscovery/csv/original_paper.csv"
    generated_file = "/home/kali/JSONSchemaDiscovery/csv/experiment_results.csv"

    # Calculate MD5 checksums using md5sum command
    original_file_hash = calculate_md5(original_file)
    generated_file_hash = calculate_md5(generated_file)

    print(f"Hash value (Original_file): {original_file_hash}")
    print(f"Hash value (Generated_file): {generated_file_hash}")

    if original_file_hash == generated_file_hash:
        print("\nBoth files are identical as their hash values match.")
        print("\nHence reproduction is confirmed")
    else:
        # Perform diff using diff command
        file_diff = subprocess.run(['diff', original_file, generated_file], capture_output=True, text=True)
        if file_diff.stdout:
            print("\nDifferences in files found:")
            print(file_diff.stdout)
            print("\nHence reproduction cannot be confirmed due to differences")
        else:
            print("\nThe content of both CSV files are functionally identical.")
            print("\nHence reproduction is confirmed")


if __name__ == "__main__":
    # Run the comparison
    compare_schemas()
