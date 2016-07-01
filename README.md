# VModel
这是一个简单的json转model框架,对NSObject的做了一个扩展。


# Usage

## 导入

### 直接导入

直接将sdk中的文件拖入到工程中即可
### pod 导入
1 先搜索 `$ pod search VModel`，如果搜索不到使用`$ pod setup`更新本地pods库.

2 在Podfile文件中添加 `pod 'VModel'`

3 执行`$ pod install --verbose --no-repo-update` 即可



## 使用
1 创建好对应的model

2 如果model中的某些字段与json中对应的key不一致,可以使用`NSObject+VModel.h`中`- (NSDictionary *)v_modelPropertyMapper`方法进行映射。

3 调用`NSObject+VModel.h`中的`- (instancetype)initVModelWithJSON:(id)json`,把json数据传入进去即可

具体使用方法，请参考库中的demo



# 许可证

MIT

# 贡献
这个框架主要的思想，来源于公司的大牛`炎帝`。

原来的框架的使用要继承与`BaseModle`











