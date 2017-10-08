インストール手順
1.
windows版のOpenSSHを
「https://github.com/PowerShell/Win32-OpenSSH/releases」
よりダウンロードし、このファイルと同じ場所に
「OpenSSH-Win32.zip」
という名前で置く。
2.
PowerShellを管理者権限で開き、このファイルが有るフォルダまで移動してから、
「./setup_win_openssh.ps1」
を実行する
これにより、インストールが始まるので、終了したらこのマシンを再起動してください。

なお、エラーが発生した場合は、PowerShell スクリプトの実行ポリシーの問題が考えられるため、
以下のコマンドを使用してポリシーを変更してください。
「Set-ExecutionPolicy Unrestricted」

参考サイト:https://technet.microsoft.com/ja-jp/library/ee176961.aspx