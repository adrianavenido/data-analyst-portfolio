Here’s a solid list of Jupyter Notebook commands to help you review data efficiently:

### General Notebook Commands:
1. `Shift + Enter` - Run the current cell.
2. `Ctrl + Enter` - Run cell, but don't move to next.
3. `Alt + Enter` - Run cell and insert a new one.
4. `Esc + A` - Insert cell above.
5. `Esc + B` - Insert cell below.
6. `Esc + D,D` - Delete the selected cell.
7. `Esc + M` - Convert cell to Markdown.
8. `Esc + Y` - Convert cell to code.
9. `Esc + R` - Convert cell to raw text.
10. `Esc + C` - Copy cell.

### Data Inspection & Manipulation:
11. `df.head()` - Show top rows of DataFrame.
12. `df.tail()` - Show bottom rows.
13. `df.shape` - Display row & column count.
14. `df.info()` - Show DataFrame details.
15. `df.describe()` - Quick stats summary.
16. `df.columns` - Get column names.
17. `df.dtypes` - Show column data types.
18. `df.isnull().sum()` - Check for missing values.
19. `df.dropna()` - Remove missing values.
20. `df.fillna(value)` - Fill missing values.

### Data Filtering:
21. `df[df['column'] > value]` - Filter rows.
22. `df[df['column'] == 'condition']` - Exact match filter.
23. `df.loc[row, col]` - Select data by labels.
24. `df.iloc[row, col]` - Select data by position.
25. `df.sort_values(by='column')` - Sort values.

### Data Aggregation:
26. `df['column'].value_counts()` - Count unique values.
27. `df.groupby('column').mean()` - Group & average.
28. `df.groupby('column').sum()` - Group & sum.
29. `df.groupby(['col1', 'col2']).size()` - Group multiple columns.
30. `df.pivot_table(index='column', values='col', aggfunc='mean')` - Pivot table.

### Plotting & Visualization:
31. `import matplotlib.pyplot as plt` - Import Matplotlib.
32. `df.plot(kind='line')` - Line chart.
33. `df.plot(kind='bar')` - Bar chart.
34. `df.plot(kind='hist')` - Histogram.
35. `df.plot(kind='box')` - Box plot.
36. `df.plot(kind='scatter', x='col1', y='col2')` - Scatter plot.
37. `plt.show()` - Display plots.

### Advanced Pandas Operations:
38. `df.set_index('column')` - Set a new index.
39. `df.reset_index()` - Reset index.
40. `df.apply(func)` - Apply function to DataFrame.
41. `df.replace({'old': 'new'})` - Replace values.
42. `df.rename(columns={'old_name': 'new_name'})` - Rename columns.
43. `df.merge(df2, on='column')` - Merge DataFrames.

### NumPy Operations:
44. `import numpy as np` - Import NumPy.
45. `np.array([1,2,3])` - Create NumPy array.
46. `np.mean(array)` - Mean of array.
47. `np.median(array)` - Median of array.
48. `np.std(array)` - Standard deviation.
49. `np.reshape(array, (rows, cols))` - Reshape array.

### Machine Learning Basics:
50. `from sklearn.model_selection import train_test_split` - Split data.
51. `from sklearn.linear_model import LinearRegression` - Import regression model.
52. `model.fit(X, y)` - Train model.
53. `model.predict(X_test)` - Make predictions.

### Debugging & Error Handling:
54. `%debug` - Debug last error.
55. `try: ... except:` - Handle exceptions.
56. `%timeit df.head()` - Time execution.

### Magic Commands:
57. `%time` - Check execution time.
58. `%history` - Show command history.
59. `%who` - List variables.
60. `%matplotlib inline` - Show plots in the notebook.
61. `%store var` - Store variable.

### File Handling:
62. `df.to_csv('file.csv')` - Save DataFrame to CSV.
63. `pd.read_csv('file.csv')` - Load CSV file.
64. `df.to_excel('file.xlsx')` - Save as Excel.
65. `pd.read_excel('file.xlsx')` - Read Excel file.
66. `df.to_json('file.json')` - Convert to JSON.
67. `pd.read_json('file.json')` - Read JSON file.

### String Operations:
68. `df['column'].str.contains('text')` - Check if column contains text.
69. `df['column'].str.upper()` - Convert text to uppercase.
70. `df['column'].str.lower()` - Convert text to lowercase.
71. `df['column'].str.replace('old', 'new')` - Replace strings.

### Date & Time Operations:
72. `pd.to_datetime(df['column'])` - Convert column to datetime.
73. `df['column'].dt.year` - Extract year.
74. `df['column'].dt.month` - Extract month.

### DataFrame Modifications:
75. `df.drop(columns=['col1', 'col2'])` - Drop multiple columns.
76. `df.drop_duplicates()` - Remove duplicate rows.
77. `df.sample(n=5)` - Random sample.

### Exporting Graphics:
78. `plt.savefig('figure.png')` - Save plot.

### Interactive Widgets:
79. `from ipywidgets import interact` - Import interactive widgets.

### Markdown Formatting:
80. `# Title` - Large heading.
81. `*Italic*` - Italic text.
82. `**Bold**` - Bold text.

### System Commands:
83. `!ls` - List files.
84. `!pwd` - Show current directory.
85. `!mkdir new_folder` - Create folder.

### TensorFlow & Keras:
86. `import tensorflow as tf` - Load TensorFlow.
87. `tf.keras.models.Sequential()` - Define model.
88. `model.compile(loss='mse', optimizer='adam')` - Compile model.

### Regex Operations:
89. `df['column'].str.match('regex')` - Match regex.

### Environment Variables:
90. `%env` - Show environment variables.

### Memory Optimization:
91. `df.memory_usage()` - Check memory usage.

### Data Type Conversions:
92. `df['column'].astype('int')` - Convert type.

### Running External Scripts:
93. `%run script.py` - Run script.

### Running Shell Commands:
94. `!pip install package` - Install package.

### Clipboard Operations:
95. `df.to_clipboard()` - Copy DataFrame to clipboard.

### Running SQL Queries:
96. `import sqlite3` - Import SQLite.
97. `conn = sqlite3.connect('database.db')` - Connect to DB.
98. `pd.read_sql_query('SELECT * FROM table', conn)` - Read SQL query.

### JSON Parsing:
99. `import json` - Import JSON module.
100. `json.loads(data)` - Parse JSON string.

Hope this gives you a solid foundation for reviewing data efficiently in Jupyter Notebook! 🚀 Let me know if you need to dive deeper into anything.