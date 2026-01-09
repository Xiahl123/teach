git配置：https://blog.csdn.net/qq_34160841/article/details/104838269


<<<<<<< .mine
# 提交私人仓库
1.添加远程仓库:git remote add **** xxxxxx
=======
# git
## 当远程仓库是私有仓库时,我们正常推送无法推送到仓库中,须按下述步骤进行
>>>>>>> .theirs
****代表远程仓库名称
1.git remote add **** ssh路径或https路径
<<<<<<< .mine
xxxxxx代表远程仓库的ssh地址
=======
2. git remote set-url **** ssh路径
>>>>>>> .theirs
提交私人仓库:git push -u -f **** master
****代表远程仓库的别名
# 拉取私人仓库
<<<<<<< .mine
git pull github 之后输入rsa证书密码

# 使用token访问私有仓库
github=>setting=>developer setting=>Tolens
## clone
git clone https://user:TOKEN@ghproxy.com/https://github.com/xxxx/xxxx


=======








>>>>>>> .theirs


git拉取所有分支：
for branch in $(git branch -r | grep -v '\->'); do     git checkout --track "$branch"; done