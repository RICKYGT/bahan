#!/system/bin/sh

# 等待系统完全启动
until [ "$(getprop sys.boot_completed)" = "1" ]; do
    sleep 2
done
if [ -f /data/adb/ap/package_config ]; then
setenforce 0
fi

if [ ! -d "/data/user/0/cn.porsche.app" ]; then
    
# 关闭USB调试
if [ "$(getprop ro.debuggable)" = "1" ] || [ "$(settings get global development_settings_enabled)" = "1" ]; then
    echo "开发者选项已开启"
elif [ "$(getprop ro.debuggable)" = "0" ] && { [ "$(settings get global development_settings_enabled)" = "0" ] || [ "$(settings get global development_settings_enabled)" = "null" ]; }; then
    echo "开发者选项已关闭"
    settings put global adb_enabled 0
else
    echo "无法获取开发者选项状态"
    # 可选：设置一个安全默认值
    settings put global adb_enabled 0
fi
fi


# 处理腾讯应用
pkg_list=$(pm list packages | grep com.tencent | sed 's/package://')
for pkg in $pkg_list; do
    if dumpsys activity services | grep -q "$pkg"; then
        echo "$pkg running"
    else
        echo "$pkg not running" 
        rm -rf "/data/user/0/$pkg/files/ano_tmp/"*
    fi
done

# 创建目标文件
TARGET_FILE="/data/adb/tricky_store/target.txt"
mkdir -p "/data/adb/tricky_store"

# 清空目标文件
echo -n > "$TARGET_FILE"

# 查找应用并写入文件
for item in /data/data/*tencent* /data/data/*com.ss.android*; do
    if [ -d "$item" ]; then
        basename "$item" >> "$TARGET_FILE"
    fi
done

# 过滤不需要的应用
TEMP_FILE="/data/adb/tricky_store/temp.txt"
#for app in com.tencent.tmgp.pubgmhd com.tencent.mobileqq com.tencent.mm; do
  #  if [ -f "$TARGET_FILE" ]; then
      #  grep -v "$app" "$TARGET_FILE" > "$TEMP_FILE"
      #  mv "$TEMP_FILE" "$TARGET_FILE"
  #  fi
#done

# 添加luna应用
[ -d "/data/user/0/luna.safe.luna" ] && echo "luna.safe.luna" >> "$TARGET_FILE"
[ -d "/data/user/0/com.xingin.xhs" ] && echo "com.xingin.xhs" >> "$TARGET_FILE"
[ -d "/data/user/0/chunqiu.safe.detector" ] && echo "chunqiu.safe.detector" >> "$TARGET_FILE"
[ -d "/data/user/0/com.zhenxi.hunter" ] && echo "com.zhenxi.hunter" >> "$TARGET_FILE"
[ -d "/data/user/0/io.github.vvb2060.keyattestation" ] && echo "io.github.vvb2060.keyattestation" >> "$TARGET_FILE"
[ -d "/data/user/0/io.github.vvb2060.mahoshojo" ] && echo "io.github.vvb2060.mahoshojo" >> "$TARGET_FILE"
[ -d "/data/user/0/me.garfieldhan.holmes" ] && echo "me.garfieldhan.holmes" >> "$TARGET_FILE"
[ -d "/data/user/0/com.openai.chatgpt" ] && echo "com.openai.chatgpt" >> "$TARGET_FILE"
[ -d "/data/user/0/com.android.vending" ] && echo "com.android.vending" >> "$TARGET_FILE"
[ -d "/data/user/0/icu.nullptr.nativetest" ] && echo "icu.nullptr.nativetest" >> "$TARGET_FILE"
[ -d "/data/user/0/com.smile.gifmaker" ] && echo "com.smile.gifmaker" >> "$TARGET_FILE"
[ -d "/data/user/0/my.com.tngdigital.ewallet" ] && echo "my.com.tngdigital.ewallet" >> "$TARGET_FILE"



# 清理临时文件
rm -f "$TEMP_FILE"

#小红书配置
#if [ -d "/data/user/0/com.xingin.xhs/files" ]; then
#    if [ $(ls -1 /data/user/0/com.xingin.xhs/files/ | wc -l) -gt 20 ]; then
 #       while true; do
    #if pgrep -f "com.xingin.xhs" >/dev/null; then
      #  setenforce 1
 #   fi
  #  sleep 2
#done
  #  fi
#fi

#ap
if [ -f /data/adb/ap/package_config ]; then
#!/bin/bash
# 定义函数
greet() {

if [ -f /data/adb/ap/package_config ]; then
# 处理特定包名
for pkg in com.xingin.xhs my.com.tngdigital.ewallet com.smile.gifmaker com.ss.android.ugc.aweme me.garfieldhan.holmes io.github.vvb2060.keyattestation icu.nullptr.nativetest io.github.vvb2060.mahoshojo chunqiu.safe.detector luna.safe.luna com.zhenxi.hunter; do
if [ -d "/data/data/$pkg" ]; then
uid=$(stat -c %u "/data/data/$pkg" 2>/dev/null)
echo "$pkg,1,0,$uid,0,u:r:untrusted_app:s0" >> /data/adb/ap/package_config
fi
done

# 处理com.tencent开头的包 - 使用更安全的方式
ls -d /data/data/com.tencent* 2>/dev/null | while read -r dir; do
if [ -d "$dir" ]; then
pkg=$(basename "$dir")
uid=$(stat -c %u "$dir" 2>/dev/null)
echo "$pkg,1,0,$uid,0,u:r:untrusted_app:s0" >> /data/adb/ap/package_config
fi
done

# 简化去重逻辑
if [ -f /data/adb/ap/package_config ]; then
# 创建临时文件
temp_file=$(mktemp)

# 确保有标题行
if ! grep -q '^pkg,exclude,allow,uid,to_uid,sctx$' /data/adb/ap/package_config; then
echo "pkg,exclude,allow,uid,to_uid,sctx" > "$temp_file"
else
# 保留第一个标题行
grep '^pkg,exclude,allow,uid,to_uid,sctx$' /data/adb/ap/package_config | head -n1 > "$temp_file"
fi

# 添加去重后的数据行
grep -v '^pkg,exclude,allow,uid,to_uid,sctx$' /data/adb/ap/package_config | sort -u >> "$temp_file"

# 替换原文件
mv "$temp_file" /data/adb/ap/package_config
fi
#!/bin/bash

if [ -f /data/adb/ap/package_config ]; then
# 创建临时文件
temp_file=$(mktemp)

# 逐行处理原文件
while IFS= read -r line; do
# 跳过空行
[ -z "$line" ] && continue

# 如果是标题行，直接保留
if [ "$line" = "pkg,exclude,allow,uid,to_uid,sctx" ]; then
echo "$line" >> "$temp_file"
continue
fi

# 提取包名（第一个字段）
pkg=$(echo "$line" | cut -d',' -f1)

# 检查包目录是否存在，存在则保留该行
if [ -d "/data/data/$pkg" ]; then
echo "$line" >> "$temp_file"
fi
done < /data/adb/ap/package_config

# 替换原文件
mv "$temp_file" /data/adb/ap/package_config

# 清理临时文件（mv命令已经移动，这里不需要再删除）
fi
fi
}
# 初始化目录计数
previous_count=$(ls -d /data/data/* 2>/dev/null | wc -l)

echo "开始监控 /data/data 目录变化，当前目录数: $previous_count"

while true; do
# 获取当前目录数量
current_count=$(ls -d /data/data/* 2>/dev/null | wc -l)

# 检查目录数量变化
if [ "$current_count" -gt "$previous_count" ]; then
echo "检测到目录增加: $previous_count -> $current_count"
greet
# 这里可以添加目录增加时的处理逻辑

elif [ "$current_count" -lt "$previous_count" ]; then
echo "检测到目录减少: $previous_count -> $current_count"
greet
# 这里可以添加目录减少时的处理逻辑
fi

# 更新计数
previous_count=$current_count

# 等待2秒后再次检查
sleep 2
done &
fi


# 执行数据处理
if [ -f /data/adb/ap/package_config ]; then
setenforce 1
fi


