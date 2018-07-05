import pandas

path_medium_csv = 'test-data/medium_csv.csv'

pandas_col_specs = {
  'GlobalRank':float, 'TldRank':float, 'Domain':str,
  'TLD':str, 'RefSubNets':float, 'RefIPs':float,
  'IDN_Domain':str, 'IDN_TLD':str, 'PrevGlobalRank':float,
  'PrevTldRank':float, 'PrevRefSubNets':float, 'PrevRefIPs':float
  }

df = pandas.read_csv(filepath_or_buffer = path_medium_csv,
                     dtype = pandas_col_specs, low_memory = False)
