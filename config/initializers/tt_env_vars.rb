ENV['CATALYST_URL'] = "http://localhost:9004" if ENV['CATALYST_URL'] == nil
ENV['SAVE_EXPORT_PATH'] = "/home/user/export_out" if ENV['SAVE_EXPORT_PATH'] == nil

# Paths to sync data to
ENV['SYNC_JSONDATA_PATH'] = "/home/user/ocr_out2/ocred_docs" if ENV['SYNC_JSONDATA_PATH'] == nil
ENV['SYNC_RAWDOC_PATH'] = "/home/user/ocr_out2/raw_docs" if ENV['SYNC_RAWDOC_PATH'] == nil
ENV['SYNC_CONFIG_PATH'] = "/home/user/TT/Code/Archives/Ansible/DM_pub_test/dataspec_files" if ENV['SYNC_CONFIG_PATH'] == nil
