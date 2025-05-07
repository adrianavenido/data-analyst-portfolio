# ---------------------------------------------------------------
# DISCLAIMER:
# This script contains reconstructed logic based on a proprietary
# cash application automation system developed during my previous
# employment. Original source code and data are not included.
#
# All development was done manually, prior to the public release
# of ChatGPT (Nov 30, 2022), using personal research, testing,
# and resources such as Stack Overflow and official documentation.
# ---------------------------------------------------------------

import pandas as pd

def generate_vbs_from_excel(excel_path):
    df = pd.read_excel(excel_path)
    vbs_lines = []
    vbs_lines.append("If Not IsObject(application) Then")
    vbs_lines.append('   Set SapGuiAuto = GetObject("SAPGUI")')
    vbs_lines.append('   Set application = SapGuiAuto.GetScriptingEngine')
    vbs_lines.append("End If")
    vbs_lines.append("Set connection = application.Children(0)")
    vbs_lines.append("Set session = connection.Children(0)")
    vbs_lines.append('session.findById("wnd[0]/tbar[0]/okcd").text = "/nF-28"')
    vbs_lines.append('session.findById("wnd[0]").sendVKey 0')

    for _, row in df.iterrows():
        vbs_lines.append(f'session.findById("wnd[0]/usr/ctxtRF05L-KUNNR").text = "{row["Customer"]}"')
        vbs_lines.append('session.findById("wnd[0]").sendVKey 0')
        vbs_lines.append(f'session.findById("wnd[0]/usr/tblSAPMF05LTC_LINE/txtBSEG-BELNR[0,0]").text = "{row["Invoice"]}"')
        vbs_lines.append(f'session.findById("wnd[0]/usr/tblSAPMF05LTC_LINE/txtBSEG-WRBTR[1,0]").text = "{row["Amount"]}"')
        vbs_lines.append('session.findById("wnd[0]").sendVKey 0')

    vbs_lines.append('session.findById("wnd[0]/tbar[0]/btn[11]").press')
    vbs_lines.append('MsgBox "SAP Cash Posting Complete!"')
    
    with open("../sap_scripts/auto_cash_posting.vbs", "w") as file:
        for line in vbs_lines:
            file.write(line + "\n")

if __name__ == "__main__":
    generate_vbs_from_excel("../data/remittance_sample.xlsx")
