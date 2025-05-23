import matplotlib.pyplot as plt
import matplotlib.patches as mpatches

# Create a simple diagram illustrating the flow of data

fig, ax = plt.subplots(figsize=(12, 6))

# Elements in the flow
steps = [
    "User Asks Question", 
    "Write SQL Query", 
    "Database Processes Query", 
    "Returns Data Table", 
    "Analyze with Python (Jupyter)"
]

# Positions for the boxes
positions = [(1, 3), (3, 3), (5, 3), (7, 3), (9, 3)]

# Draw boxes
for (x, y), text in zip(positions, steps):
    ax.add_patch(mpatches.FancyBboxPatch((x-0.8, y-0.5), 1.6, 1,
                                         boxstyle="round,pad=0.1",
                                         edgecolor='black', facecolor='lightblue'))
    ax.text(x, y, text, ha='center', va='center', fontsize=10)

# Draw arrows
for i in range(len(positions) - 1):
    x_start = positions[i][0] + 0.8
    x_end = positions[i+1][0] - 0.8
    y = positions[i][1]
    ax.annotate("",
                xy=(x_end, y), xycoords='data',
                xytext=(x_start, y), textcoords='data',
                arrowprops=dict(arrowstyle="->", lw=2))

# Final plot settings
ax.set_xlim(0, 11)
ax.set_ylim(2, 4)
ax.axis('off')
plt.title("Flow of Information: User → SQL → Database → Python", fontsize=14)
plt.tight_layout()
plt.show()
