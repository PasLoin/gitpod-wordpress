# docs: https://developer.wordpress.org/cli/commands/plugin/

wp plugin delete hello
wp plugin delete akismet
wp plugin activate ${REPO_NAME}

# wp plugin install plugin_slug --activate

wp theme install realdesign
wp plugin activate ${REPO_NAME}
wp plugin install woocommerce --activate # install WooCommerce
wp plugin install coopcycle --activate # install Coopcycle plugin @see https://github.com/coopcycle/coopcycle-plugins
wp theme install storefront --activate 
wp plugin install WooCommerce-Admin --activate
wp plugin install WooCommerce-Multilingual --activate
wp plugin install WooCommerce-PDF-Invoices --activate
wp plugin install WooCommerce Stripe --activate
wp plugin install WP-File-Manager --activate
wp plugin install wp-file-manager --activate
wp plugin install Duplicator – WordPress Migration Plugin --activate
wp theme delete twentytwenty
wp theme delete TwentyNineteen
wp theme activate woo.delivery-master
wp option set woocommerce_store_address "Place de la Minoterie 10"
wp option set woocommerce_store_address_2 ""
wp option set woocommerce_store_city "Bruxelles"
wp option set woocommerce_default_country "BE"
wp option set woocommerce_store_postalcode "1080"
wp option set woocommerce_currency "EUR"
wp option set woocommerce_product_type "physical"
wp option set woocommerce_allow_tracking "no"
wp option set --format=json woocommerce_stripe_settings '{"enabled":"no","create_account":false,"email":false}'
wp option set --format=json woocommerce_ppec_paypal_settings '{"reroute_requests":false,"email":false}'
wp option set --format=json woocommerce_cheque_settings '{"enabled":"no"}'
wp option set --format=json woocommerce_bacs_settings '{"enabled":"no"}'
wp option set --format=json woocommerce_cod_settings '{"enabled":"yes"}'
wp option set Site Title "titre du site"
wp option set Tagline "Not just an another wordpress website"
wp option set blogname "Ici le nom du site"
wp option set blogdescription "Ici la description du blog"
wp wc --user=admin tool run install_pages
wp plugin install wordpress-importer --activate
wp import https://github.com/woocommerce/woocommerce/blob/master/sample-data/sample_products.xml --authors=create
wp wc product create --name="Test Product2" --type=simple --sku=WCCLITESTP1 --regular_price=201 --user=admin
wp wc product create --name="Test Product1" --type=simple --sku=0WCCLITESTP1 --regular_price=20 --user=admin
wp wc customer create --email='woo@woo.local' --user=1 --billing='{"first_name":"Bob","last_name":"Tester","company":"Woo", "address_1": "123 Main St.", "city":"New York", "state:": "NY", "country":"USA"}' --shipping='{"first_name":"Bob","last_name":"Tester","company":"Woo", "address_1": "123 Main St.", "city":"New York", "state:": "NY", "country":"USA"}' --password='hunter2' --username='mrbob' --first_name='Bob' --last_name='Tester'
wp plugin install WooCommerce-Show-Attributes --activate
wp plugin install rest-api --activate
wp --info
wp package install https://github.com/wpbullet/wp-menu-import-export-cli.git --allow-root
curl -N http://loripsum.net/api/5 | wp post generate --post_content --count=10
curl -L https://raw.githubusercontent.com/woocommerce/woocommerce/master/sample-data/sample_products.xml -o sample_data_new.xml
wp import sample_data_new.xml --authors=create
