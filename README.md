# Cách chạy docker
*Đảm bảo port 80,3306,9200 của máy host không có service nào đang listen*
1. cd vào thư mục hiện tại
2. Chạy `docker compose up -d` hoặc câu lệnh tương ứng tùy hệ điều hành
3. Container mysql sẽ khởi chạy và tạo database theo file .sql nên sẽ mất một khoảng thời gian. Kiểm tra bằng cách vào mysql container và đảm bảo database magento có 352 table (`show tables;`).
Khi đủ bảng rồi thì container php mới kết nối được tới mysql.
4. Chỉnh lại base url của web vì hiện tại đang là tên miền shoes.recurup.com
```
# Vào mysql container
UPDATE core_config_data SET VALUE = 'http://127.0.0.1/' WHERE path = 'web/unsecure/base_url';
```
5. Khi đã kết nối được tới mysql thì từ trong container php vào folder `/var/www/html/magento` và chạy `bin/magento setup:upgrade`
6. Truy cập 127.0.0.1 từ máy host để kiểm tra kết quả.

---

# Setup

1. Clone repo
2. Run `composer install`
3. Install magento, default admin route /admin
```bash
sudo bin/magento setup:install --base-url=http://127.0.0.1/ --db-host=localhost --db-name=magento --db-user=magento --db-password=1111 --admin-firstname=Magento --admin-lastname=Admin --admin-email=admin@example.com --admin-user=admin --admin-password=admin123 --language=en_US --currency=USD --timezone=America/Chicago --use-rewrites=1 --search-engine=elasticsearch7 --elasticsearch-host=localhost --elasticsearch-port=9200 --elasticsearch-index-prefix=magento2 --elasticsearch-timeout=15 --backend-frontname=admin
```
4. Set file permissions
```bash
cd /var/www/html/<magento install directory>
sudo find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} +
sudo find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} +
sudo chown -R :www-data . # Ubuntu
sudo chmod u+x bin/magento
```
5. Config apache/nginx -> Folder `/pub`

## Fix

- Reindex: `sudo bin/magento indexer:reindex`, và vào refresh cache nếu vẫn lỗi

## Seed Products

- khó

## Cài Module

1. Tải zip và thêm vào thư mục `app/code` theo cấu trúc `app/code/<Vendor>/<Module>`
2. Bật module: `sudo bin/magento module:enable <Vendor>_<Module>` (Vendor và tên Module phải giống trong file registration.php của module đó)
3. Cài đặt module: `sudo bin/magento setup:upgrade`
4. Xóa cache: `sudo bin/magento cache:clean && sudo bin/magento cache:flush`

## Sửa Boolfly/ZaloPay

- Sửa hết `Zend` trong `app/code/Boolfly/ZaloPay/Gateway/Http/Client/Zend.php` thành `Laminas`, chỉnh function call của Zend thành của Laminas
- Sửa hết `Zend` trong `app/code/Boolfly/ZaloPay/etc/di.xml` thành `Laminas`
- Cài lại module và xóa cache
- TODO: Sửa lỗi trong `/Gateway/Request/`

php bin/magento setup:upgrade

php bin/magento setup:di:compile

php bin/magento setup:static-content:deploy -f

php bin/magento cache:flush

chmod -R 777 var/ pub/ generated/

vnpay
URL: https://sandbox.vnpayment.vn/paymentv2/vpcpay.html
TerminalCode: 21QDD3BL
hashcode: HUDWOOBYHTAZMDMIWUESQIJEOSPKVUPD

## Docker

- Dump config: `sudo bin/magento app:config:dump`
- Đổi base url: `mysql> update core_config_data set value = 'http://127.0.0.1/' where path = 'web/unsecure/base_url';`
- Có thể phải restart mysql container vài lần
- Chạy:
```bash
# Máy host
docker compose up -d

# Container php
# Check connection tới mysql container
mysql -h mysql -u magento -p1111

# Xóa data cũ (chưa biết làm thế nào để backup)
bin/magento setup:uninstall

# Setup magento
bin/magento setup:install --base-url=http://127.0.0.1/ --db-host=mysql --db-name=magento --db-user=magento --db-password=1111 --admin-firstname=Magento --admin-lastname=Admin --admin-email=admin@example.com --admin-user=admin --admin-password=admin123 --language=en_US --currency=USD --timezone=America/Chicago --use-rewrites=1 --search-engine=elasticsearch7 --elasticsearch-host=elasticsearch --elasticsearch-port=9200 --elasticsearch-index-prefix=magento2 --elasticsearch-timeout=15 --backend-frontname=admin
```