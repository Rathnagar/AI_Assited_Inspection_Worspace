import streamlit as st
import pandas as pd
from snowflake.snowpark.context import get_active_session


session = get_active_session()

st.title("🏠 AI-Assisted Property Inspection Workspace")


properties = session.sql("""
    SELECT DISTINCT property_id, property_name 
    FROM PROPERTY
""").to_pandas()

selected_property = st.selectbox(
    "Select Property",
    properties["PROPERTY_ID"]
)


room_data = session.sql(f"""
    SELECT 
        r.room_id,
        r.room_type,
        f.finding_text
    FROM ROOM r
    LEFT JOIN FINDINGS f
        ON r.room_id = f.room_id
    WHERE r.property_id = '{selected_property}'
""").to_pandas()

room_data.columns = room_data.columns.str.lower()


def classify_defect(text):
    text = (text or "").lower()

    if any(w in text for w in ["crack", "beam", "foundation", "wall"]):
        return "structural", "high"
    elif any(w in text for w in ["wiring", "exposed", "short circuit"]):
        return "electrical", "high"
    elif any(w in text for w in ["leak", "damp", "water", "pipe"]):
        return "plumbing", "medium"
    elif any(w in text for w in ["paint", "tile", "plaster", "floor"]):
        return "finishing", "low"
    else:
        return "ok", "low"

room_data[["defect_type", "severity"]] = (
    room_data["finding_text"]
    .apply(lambda x: pd.Series(classify_defect(x)))
)


def risk_score(defect):
    if defect in ["structural", "electrical"]:
        return 5
    elif defect == "plumbing":
        return 4
    elif defect == "finishing":
        return 2
    return 0

room_data["risk_score"] = room_data["defect_type"].apply(risk_score)
property_risk = round(room_data["risk_score"].mean(), 2)


def summarize(df):
    high = df[df["severity"] == "high"]
    medium = df[df["severity"] == "medium"]

    summary = ""
    if not high.empty:
        summary += f"High risk: {len(high)} issues ({', '.join(high['finding_text'])}). "
    if not medium.empty:
        summary += f"Medium risk: {len(medium)} issues ({', '.join(medium['finding_text'])}). "

    if summary == "":
        summary = "No major issues detected."

    return summary

summary_text = summarize(room_data)


st.subheader("Room-Level Inspection Findings")
st.dataframe(
    room_data[
        ["room_id", "room_type", "finding_text", "defect_type", "severity", "risk_score"]
    ]
)

st.subheader("Overall Property Risk")
st.metric("Average Risk Score", property_risk)

st.subheader("Inspection Summary")
st.write(summary_text)


def color_severity(val):
    if val == "high":
        return "background-color: #ffcccc"
    elif val == "medium":
        return "background-color: #fff2cc"
    else:
        return "background-color: #ccffcc"

st.subheader("Severity Highlighted View")
st.dataframe(
    room_data.style.applymap(color_severity, subset=["severity"])
)
