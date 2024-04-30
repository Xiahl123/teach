# git
## 当远程仓库是私有仓库时,我们正常推送无法推送到仓库中,须按下述步骤进行
1.git remote add **** ssh路径或https路径
2. git remote set-url **** ssh路径
3.git push -u -f **** 分支名
4.首次提交需要输入ssh密码