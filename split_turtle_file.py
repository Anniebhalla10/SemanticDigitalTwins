import os
import sys

def split_turtle_file(input_file, output_dir, instances_per_file=100):
    # Create the output directory if it doesn't exist
    os.makedirs(output_dir, exist_ok=True)

    with open(input_file, 'r') as f:
        data = f.read()
        instances = data.split(" .\n")
        file_count = 1
        for i in range(0, len(instances), instances_per_file):
            output_file = os.path.join(output_dir, f"plumbing_{file_count}.ttl")
            with open(output_file, 'w') as out_f:
                out_f.write(" .\n".join(instances[i:i+instances_per_file]))
                out_f.write(" .\n")  # Append the "." delimiter to the end of each file
            file_count += 1

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python split_turtle_file.py input_file.ttl output_directory instances_per_file")
        sys.exit(1)

    input_file = sys.argv[1]
    output_directory = sys.argv[2]
    instances_per_file = int(sys.argv[3])
    split_turtle_file(input_file, output_directory, instances_per_file)
