import pandas as pd
import os
import re
import xml.etree.ElementTree as ET
import logging
from tqdm import tqdm

def replace_in_file(file_path, pattern, replacement):
    with open(file_path, 'r+') as file:
        file_content = file.read()
        file_content = re.sub(pattern, replacement, file_content)
        file.seek(0)
        file.write(file_content)
        file.truncate()

def replace_in_all_files(directory, pattern, replacement):
    for foldername, subfolders, filenames in os.walk(directory):
        for filename in filenames:
            file_path = os.path.join(foldername, filename)
            replace_in_file(file_path, pattern, replacement)

directory = "./data/OWOD/Annotations/"
pattern = "/name>\n        <bndbox>"
replacement = "/name>\n        <truncated>0</truncated>\n        <difficult>0</difficult>\n        <bndbox>"


def update_name_and_path(dict_csv, xml_dir, new_path_prefix):
    logging.basicConfig(filename='xml_update.log', level=logging.INFO)
    
    df = pd.read_csv(dict_csv)
    name_dict = df.set_index('old_name')['new_name'].to_dict()

    xml_files = [f for f in os.listdir(xml_dir) if f.endswith('.xml')]

    for xml_file in tqdm(xml_files, desc="Updating XML files"):
        tree = ET.parse(os.path.join(xml_dir, xml_file))
        root = tree.getroot()

        for elem in root.iter():
            try:
                if elem.tag == 'filename':
                    old_filename = elem.text.split('.')[0]
                    file_extension = elem.text.split('.')[1]

                    new_filename = f"{name_dict[old_filename]}.{file_extension}"
                    new_path = f"{new_path_prefix}{new_filename}"

                    elem.text = new_filename

                if elem.tag == 'path':
                    elem.text = new_path

            except Exception as e:
                logging.error(f"Error processing XML file {xml_file}: {e}")
                pass

        tree.write(os.path.join(xml_dir, xml_file))     

xml_dir = "./data/OWOD/Annotations/"
pattern = "/name>\n        <bndbox>"
replacement = "/name>\n        <truncated>0</truncated>\n        <difficult>0</difficult>\n        <bndbox>"
# replace_in_all_files(xml_dir, pattern, replacement)      

dict_csv = "./data/OWOD/filename_map.csv"
new_path_prefix = "/home/sabrina/code/PROB/data/OWOD/ImageSets/"
# update_name_and_path(dict_csv, xml_dir, new_path_prefix)
