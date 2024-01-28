#!/bin/bash
echo "Running smoke test..."

NODE_VERSION=$(node --version)

# Check if the last execution command was successful
if [ $? -eq 0 ]; then
    # Parsing the app version from package.json
    VERSION=$(perl -ne 'print "$1\n" if /"version": *"(.*?)"/' package.json)

    if [ $? -eq 0 ]; then
        echo "App Version: $VERSION, is running on Node version: $NODE_VERSION"
        echo "......................................"

        # Empty database previous records if any
        python3 script/delete_db.py

        echo "1). Loading datasets into the database, this might take a while..."

        # Run Python script to add records
        python3 script/add_record.py

        # Check the exit status
        if [ $? -eq 0 ]; then
            echo "............................................."
            echo "2). All dataset has been successfully loaded into the database, now beginning extraction of schema...."

            # Run Python script to evaluate and generate csv file
            python3 script/evaluate.py

            # Check the exit status
            if [ $? -eq 0 ]; then
                # update the main.tex file to reflect the generated schema values            
                python3 script/generate_pdf_values.py
                if [ $? -eq 0 ]; then
                    # compare experiment result
                    echo "............................................."
                    echo "3). Comparing the results of the experiment with the original paper's results"
                   
                    python3 script/compare_result.py

                    if [ $? -eq 0 ]; then
                        echo "..............................................."
                        echo "4). Experiment Successful. Generating PDF report"
                        make clean
                        make report
                        if [ $? -eq 0 ]; then
                            echo "........................................."
                            echo "5). PDF successfully generated"
                        fi

                        exit 0
                    else 
                        echo "............................................."
                        echo "4). Could not replace the generated values in the latex file"
                        exit 1
                    fi
                else
                    echo "............................................."
                    echo "3). Could compare experiment results"
                    exit 1
                fi
            else
                echo "............................................."
                echo "3). Failed to extract Schema."
                exit 1
            fi

        else
            echo "............................................."
            echo "2). Failed to load datasets into the database."
            exit 1
        fi
    else
        echo "............................................."
        echo "1). Failed to get NODE version"
        exit 1
    fi
else
    echo "............................................."
    echo "Failed to execute doAll.sh"
    exit 1
fi
