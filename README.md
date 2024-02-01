# files-rename

A long long time ago I asked myself: 
> what the f*ck is this?
```powershell
Get-ChildItem *.txt| Rename-Item -NewName { $_.Name -replace '\.txt','.log' }
```

So... Now, after my File Renamer crashed one too many times, I wrote my own bulk\* file renamer cli.

```
fr.exe [path] selector find replace [-h] [--no-colors]
```


`path` - path to folder, where the files are located  
`selector` - regex for selecting specific files (<find> also partially does this)  
`find` - regex for text to replace it is, by default global(/.../g)  
`replace` - regex to replace the text with  
`-y` - y[es], automatically confirms replacement  
`--no-colors` - disables ansi codes`  


*I actually remembered to publish something to Github again, huh...*
