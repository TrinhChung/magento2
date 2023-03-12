# Setup

1. Clone repo
2. Run `composer install`
3. Install magento, default admin route /admin
```bash
sudo bin/magento setup:install --base-url=http://localhost/ --db-host=localhost --db-name=magento --db-user=magento --db-password=1111 --admin-firstname=Magento --admin-lastname=Admin --admin-email=admin@example.com --admin-user=admin --admin-password=admin123 --language=en_US --currency=USD --timezone=America/Chicago --use-rewrites=1 --search-engine=elasticsearch7 --elasticsearch-host=localhost --elasticsearch-port=9200 --elasticsearch-index-prefix=magento2 --elasticsearch-timeout=15 --backend-frontname=admin
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