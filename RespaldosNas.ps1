get-childitem "\\10.10.0.41\Backups\Respaldo BD" -rec | where {!$_.PSIsContainer} | select-object FullName, LastWriteTime | export-csv -notypeinformation -delimiter ',' "Report.41.DB.D-1.csv"
get-childitem "\\10.10.0.41\Backups\RespaldoSQL" -rec | where {!$_.PSIsContainer} | select-object FullName, LastWriteTime | export-csv -notypeinformation -delimiter ',' "Report.41.SQL.DA.csv"
get-childitem "\\10.10.0.16\Respaldos BD" -rec | where {!$_.PSIsContainer} | select-object FullName, LastWriteTime | export-csv -notypeinformation -delimiter ',' "Report.16.DB.DA.csv"
