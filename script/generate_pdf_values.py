"""Regenerate pdf values after experiment execution"""
from evaluate import show_analysis

FILE_PATH = '/home/kali/JSONSchemaDiscovery/ReproEngReport/main.tex'

def generate_latex_values():
    with open(FILE_PATH, 'r+') as file:
        # Read the content of the LaTeX template
        latex_template = file.read()

        # List of values to be inserted into the LaTeX template
        list_of_values = show_analysis()
        
        # Initialize the rows string
        rows = ''

        # records from the original paper documented by Frozza et al. 
        original_paper = {"drugs":"2818", "companies": "21312", "movies":"25140"}

        # Iterate over the list_of_values and build rows
        for values in list_of_values:
            row = f"{values['collectionName']} & {values['collectionCount']} & {values['uniqueUnorderedCount']} & {values['uniqueOrderedCount']} & {original_paper[values['collectionName']]} & {original_paper[values['collectionName']]} \\\\"
            rows += row + '\n'
            rows += '\hline\n'

        # Replace %ROWS% with the generated rows in the LaTeX template
        latex_template = latex_template.replace('%ROWS%', rows)

        # Set the file position back to the beginning
        file.seek(0)

        # Write the modified LaTeX template back to the file
        file.write(latex_template)

if __name__ == '__main__':
    generate_latex_values()