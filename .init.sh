wp plugin delete hello
wp plugin delete akismet
# wp theme delete twenty-twenty
# wp theme delete Twenty-Twenty
wp theme install realdesign
wp plugin activate ${REPO_NAME}
# wp theme activate ${REPO_NAME}
wp plugin install woocommerce --activate # install WooCommerce
wp plugin install coopcycle --activate # install Coopcycle plugin @see https://github.com/coopcycle/coopcycle-plugins
wp theme install storefront --activate 
# wp plugin install Advanced-Custom-Fields-Multilingual --activate
# wp plugin install Akismet-Anti-Spam --activate
# wp plugin install-Splash-Popup-for-WooCommerce --activate	
wp plugin install WooCommerce-Admin --activate
# wp plugin install WooCommerce-Blocks --activate
wp plugin install WooCommerce-Multilingual --activate
wp plugin install WooCommerce-PDF-Invoices --activate
# wp plugin install WooCommerce-Show-Attributes --activate
wp plugin install WooCommerce-Stripe-Gateway --activate
wp plugin install WooCommerce Stripe --activate
#wp plugin install WPAllExport --activate
wp plugin install WP-All-Export --activate
wp plugin install WP-All-Import --activate
wp plugin install WP-File-Manager --activate
wp plugin install WP-Mail-SMTP-by-WPForms --activate
# wp plugin install WP-Matomo (WP-Piwik) --activate
wp plugin install WPML-All-Import --activate
wp plugin install WPML-Media --activate
wp plugin install WPML-Multilingual-CMS --activate
wp plugin install WPML-String-Translation --activate
wp plugin install WPML-Translation-Management --activate
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
wp wc --user=admin tool run install_pages
wp import wp-content/plugins/woocommerce/sample-data/sample_products.xml --authors=skip
