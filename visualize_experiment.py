import pandas as pd
import matplotlib.pyplot as plt

# ---------------------------
# Funnel chart
# ---------------------------
funnel = pd.read_csv("funnel.csv")

plt.figure()
plt.bar(funnel["event_type"], funnel["count"])
plt.title("User Funnel")
plt.xlabel("Event Type")
plt.ylabel("Count")
plt.tight_layout()
plt.show()

# ---------------------------
# Conversion by variant
# ---------------------------
conv = pd.read_csv("conversion_by_variant.csv")

plt.figure()
plt.bar(conv["variant"], conv["conversion"])
plt.title("Conversion Rate by Variant")
plt.xlabel("Variant")
plt.ylabel("Conversion Rate")
plt.tight_layout()
plt.show()

# ---------------------------
# Weekly conversion trend
# ---------------------------
weekly = pd.read_csv("weekly_conversion.csv")
weekly["week"] = pd.to_datetime(weekly["week"])

plt.figure()
for variant in weekly["variant"].unique():
    subset = weekly[weekly["variant"] == variant]
    plt.plot(subset["week"], subset["conversion"], marker="o", label=variant)

plt.title("Weekly Conversion Rate Trend (A/B Test)")
plt.xlabel("Week")
plt.ylabel("Conversion Rate")
plt.legend(title="Variant")
plt.tight_layout()
plt.show()
import pandas as pd
import matplotlib.pyplot as plt

# ---------- Load data ----------
funnel = pd.read_csv("funnel.csv")
conversion = pd.read_csv("conversion_by_variant.csv")
weekly = pd.read_csv("weekly_conversion.csv")

# ---------- Funnel plot ----------
plt.figure()
plt.bar(funnel["event_type"], funnel["count"])
plt.title("User Funnel")
plt.xlabel("Event Type")
plt.ylabel("Count")
plt.tight_layout()
plt.show()

# ---------- Conversion by variant ----------
plt.figure()
plt.bar(conversion["variant"], conversion["conversion"])
plt.title("Conversion Rate by Variant")
plt.xlabel("Variant")
plt.ylabel("Conversion Rate")
plt.tight_layout()
plt.show()

# ---------- Weekly conversion trend ----------
weekly["week"] = pd.to_datetime(weekly["week"])

for variant in weekly["variant"].unique():
    subset = weekly[weekly["variant"] == variant]
    plt.plot(subset["week"], subset["conversion"], label=variant)

plt.title("Weekly Conversion Trend")
plt.xlabel("Week")
plt.ylabel("Conversion Rate")
plt.legend()
plt.tight_layout()
plt.show()

