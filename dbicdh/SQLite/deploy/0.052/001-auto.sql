-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Mon Apr 20 16:02:06 2015
-- 

;
BEGIN TRANSACTION;
--
-- Table: addresses
--
CREATE TABLE addresses (
  addresses_id INTEGER PRIMARY KEY NOT NULL,
  users_id integer NOT NULL,
  type varchar(16) NOT NULL DEFAULT '',
  archived boolean NOT NULL DEFAULT 0,
  first_name varchar(255) NOT NULL DEFAULT '',
  last_name varchar(255) NOT NULL DEFAULT '',
  company varchar(255) NOT NULL DEFAULT '',
  address varchar(255) NOT NULL DEFAULT '',
  address_2 varchar(255) NOT NULL DEFAULT '',
  postal_code varchar(255) NOT NULL DEFAULT '',
  city varchar(255) NOT NULL DEFAULT '',
  phone varchar(32) NOT NULL DEFAULT '',
  states_id integer,
  country_iso_code char(2) NOT NULL,
  created datetime NOT NULL,
  last_modified datetime NOT NULL,
  FOREIGN KEY (country_iso_code) REFERENCES countries(country_iso_code) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (states_id) REFERENCES states(states_id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (users_id) REFERENCES users(users_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX addresses_idx_country_iso_code ON addresses (country_iso_code);
CREATE INDEX addresses_idx_states_id ON addresses (states_id);
CREATE INDEX addresses_idx_users_id ON addresses (users_id);
--
-- Table: attribute_values
--
CREATE TABLE attribute_values (
  attribute_values_id INTEGER PRIMARY KEY NOT NULL,
  attributes_id integer NOT NULL,
  value varchar(255) NOT NULL,
  title varchar(255) NOT NULL DEFAULT '',
  priority integer NOT NULL DEFAULT 0,
  FOREIGN KEY (attributes_id) REFERENCES attributes(attributes_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX attribute_values_idx_attributes_id ON attribute_values (attributes_id);
--
-- Table: attributes
--
CREATE TABLE attributes (
  attributes_id INTEGER PRIMARY KEY NOT NULL,
  name varchar(255) NOT NULL,
  type varchar(255) NOT NULL DEFAULT '',
  title varchar(255) NOT NULL DEFAULT '',
  dynamic boolean NOT NULL DEFAULT 0,
  priority integer NOT NULL DEFAULT 0
);
--
-- Table: cart_products
--
CREATE TABLE cart_products (
  cart_products_id INTEGER PRIMARY KEY NOT NULL,
  carts_id integer NOT NULL,
  sku varchar(64) NOT NULL,
  cart_position integer NOT NULL,
  quantity integer NOT NULL DEFAULT 1,
  created datetime NOT NULL,
  last_modified datetime NOT NULL,
  FOREIGN KEY (carts_id) REFERENCES carts(carts_id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (sku) REFERENCES products(sku) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX cart_products_idx_carts_id ON cart_products (carts_id);
CREATE INDEX cart_products_idx_sku ON cart_products (sku);
--
-- Table: carts
--
CREATE TABLE carts (
  carts_id INTEGER PRIMARY KEY NOT NULL,
  name varchar(255) NOT NULL DEFAULT '',
  users_id integer,
  sessions_id varchar(255),
  created datetime NOT NULL,
  last_modified datetime NOT NULL,
  approved boolean,
  status varchar(32) NOT NULL DEFAULT '',
  FOREIGN KEY (sessions_id) REFERENCES sessions(sessions_id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (users_id) REFERENCES users(users_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX carts_idx_sessions_id ON carts (sessions_id);
CREATE INDEX carts_idx_users_id ON carts (users_id);
CREATE UNIQUE INDEX carts_name_sessions_id ON carts (name, sessions_id);
--
-- Table: countries
--
CREATE TABLE countries (
  country_iso_code char(2) NOT NULL DEFAULT '',
  scope varchar(32) NOT NULL DEFAULT '',
  name varchar(255) NOT NULL DEFAULT '',
  priority integer NOT NULL DEFAULT 0,
  show_states boolean NOT NULL DEFAULT 0,
  active boolean NOT NULL DEFAULT 1,
  PRIMARY KEY (country_iso_code)
);
--
-- Table: group_pricing
--
CREATE TABLE group_pricing (
  group_pricing_id INTEGER PRIMARY KEY NOT NULL,
  sku varchar(64) NOT NULL,
  quantity integer NOT NULL DEFAULT 0,
  roles_id integer NOT NULL,
  price numeric(10,2) NOT NULL DEFAULT 0.0,
  FOREIGN KEY (sku) REFERENCES products(sku) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (roles_id) REFERENCES roles(roles_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX group_pricing_idx_sku ON group_pricing (sku);
CREATE INDEX group_pricing_idx_roles_id ON group_pricing (roles_id);
--
-- Table: inventory
--
CREATE TABLE inventory (
  sku varchar(64) NOT NULL,
  quantity integer NOT NULL DEFAULT 0,
  PRIMARY KEY (sku),
  FOREIGN KEY (sku) REFERENCES products(sku) ON DELETE CASCADE ON UPDATE CASCADE
);
--
-- Table: media_displays
--
CREATE TABLE media_displays (
  media_displays_id INTEGER PRIMARY KEY NOT NULL,
  media_types_id integer NOT NULL,
  type varchar(255) NOT NULL,
  name varchar(255),
  path varchar(255),
  size varchar(255),
  FOREIGN KEY (media_types_id) REFERENCES media_types(media_types_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX media_displays_idx_media_types_id ON media_displays (media_types_id);
CREATE UNIQUE INDEX media_types_id_type_unique ON media_displays (media_types_id, type);
--
-- Table: media_products
--
CREATE TABLE media_products (
  media_products_id INTEGER PRIMARY KEY NOT NULL,
  media_id integer NOT NULL,
  sku varchar(64) NOT NULL,
  FOREIGN KEY (media_id) REFERENCES media(media_id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (sku) REFERENCES products(sku) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX media_products_idx_media_id ON media_products (media_id);
CREATE INDEX media_products_idx_sku ON media_products (sku);
CREATE UNIQUE INDEX media_id_sku_unique ON media_products (media_id, sku);
--
-- Table: media_types
--
CREATE TABLE media_types (
  media_types_id INTEGER PRIMARY KEY NOT NULL,
  type varchar(32) NOT NULL
);
CREATE UNIQUE INDEX media_types_type_key ON media_types (type);
--
-- Table: merchandising_attributes
--
CREATE TABLE merchandising_attributes (
  merchandising_attributes_id INTEGER PRIMARY KEY NOT NULL,
  merchandising_products_id integer NOT NULL,
  name varchar(32) NOT NULL,
  value text NOT NULL,
  FOREIGN KEY (merchandising_products_id) REFERENCES merchandising_products(merchandising_products_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX merchandising_attributes_idx_merchandising_products_id ON merchandising_attributes (merchandising_products_id);
--
-- Table: merchandising_products
--
CREATE TABLE merchandising_products (
  merchandising_products_id INTEGER PRIMARY KEY NOT NULL,
  sku varchar(64),
  sku_related varchar(64),
  type varchar(32) NOT NULL DEFAULT '',
  FOREIGN KEY (sku) REFERENCES products(sku) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (sku_related) REFERENCES products(sku) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX merchandising_products_idx_sku ON merchandising_products (sku);
CREATE INDEX merchandising_products_idx_sku_related ON merchandising_products (sku_related);
--
-- Table: message_types
--
CREATE TABLE message_types (
  message_types_id INTEGER PRIMARY KEY NOT NULL,
  name varchar(255) NOT NULL,
  active boolean NOT NULL DEFAULT 1
);
CREATE UNIQUE INDEX message_types_name_unique ON message_types (name);
--
-- Table: navigation
--
CREATE TABLE navigation (
  navigation_id INTEGER PRIMARY KEY NOT NULL,
  uri varchar(255) NOT NULL DEFAULT '',
  type varchar(32) NOT NULL DEFAULT '',
  scope varchar(32) NOT NULL DEFAULT '',
  name varchar(255) NOT NULL DEFAULT '',
  description varchar(1024) NOT NULL DEFAULT '',
  alias integer NOT NULL DEFAULT 0,
  parent_id integer,
  priority integer NOT NULL DEFAULT 0,
  product_count integer NOT NULL DEFAULT 0,
  created datetime NOT NULL,
  last_modified datetime NOT NULL,
  active boolean NOT NULL DEFAULT 1,
  FOREIGN KEY (parent_id) REFERENCES navigation(navigation_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX navigation_idx_parent_id ON navigation (parent_id);
CREATE UNIQUE INDEX navigation_uri_key ON navigation (uri);
--
-- Table: navigation_attributes
--
CREATE TABLE navigation_attributes (
  navigation_attributes_id INTEGER PRIMARY KEY NOT NULL,
  navigation_id integer NOT NULL,
  attributes_id integer NOT NULL,
  FOREIGN KEY (attributes_id) REFERENCES attributes(attributes_id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (navigation_id) REFERENCES navigation(navigation_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX navigation_attributes_idx_attributes_id ON navigation_attributes (attributes_id);
CREATE INDEX navigation_attributes_idx_navigation_id ON navigation_attributes (navigation_id);
--
-- Table: navigation_attributes_values
--
CREATE TABLE navigation_attributes_values (
  navigation_attributes_values_id INTEGER PRIMARY KEY NOT NULL,
  navigation_attributes_id integer NOT NULL,
  attribute_values_id integer NOT NULL,
  FOREIGN KEY (attribute_values_id) REFERENCES attribute_values(attribute_values_id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (navigation_attributes_id) REFERENCES navigation_attributes(navigation_attributes_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX navigation_attributes_values_idx_attribute_values_id ON navigation_attributes_values (attribute_values_id);
CREATE INDEX navigation_attributes_values_idx_navigation_attributes_id ON navigation_attributes_values (navigation_attributes_id);
--
-- Table: navigation_products
--
CREATE TABLE navigation_products (
  sku varchar(64) NOT NULL,
  navigation_id integer NOT NULL,
  type varchar(16) NOT NULL DEFAULT '',
  PRIMARY KEY (sku, navigation_id),
  FOREIGN KEY (navigation_id) REFERENCES navigation(navigation_id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (sku) REFERENCES products(sku) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX navigation_products_idx_navigation_id ON navigation_products (navigation_id);
CREATE INDEX navigation_products_idx_sku ON navigation_products (sku);
--
-- Table: orderlines
--
CREATE TABLE orderlines (
  orderlines_id INTEGER PRIMARY KEY NOT NULL,
  orders_id integer NOT NULL,
  order_position integer NOT NULL DEFAULT 0,
  sku varchar(64) NOT NULL,
  name varchar(255) NOT NULL DEFAULT '',
  short_description varchar(500) NOT NULL DEFAULT '',
  description text NOT NULL,
  weight numeric(10,3) NOT NULL DEFAULT 0.0,
  quantity integer,
  price numeric(10,2) NOT NULL DEFAULT 0.0,
  subtotal numeric(11,2) NOT NULL DEFAULT 0.0,
  shipping numeric(11,2) NOT NULL DEFAULT 0.0,
  handling numeric(11,2) NOT NULL DEFAULT 0.0,
  salestax numeric(11,2) NOT NULL DEFAULT 0.0,
  status varchar(24) NOT NULL DEFAULT '',
  FOREIGN KEY (orders_id) REFERENCES orders(orders_id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (sku) REFERENCES products(sku) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX orderlines_idx_orders_id ON orderlines (orders_id);
CREATE INDEX orderlines_idx_sku ON orderlines (sku);
--
-- Table: orderlines_shipping
--
CREATE TABLE orderlines_shipping (
  orderlines_id integer NOT NULL,
  addresses_id integer NOT NULL,
  shipments_id integer NOT NULL,
  PRIMARY KEY (orderlines_id, addresses_id),
  FOREIGN KEY (addresses_id) REFERENCES addresses(addresses_id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (orderlines_id) REFERENCES orderlines(orderlines_id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (shipments_id) REFERENCES shipments(shipments_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX orderlines_shipping_idx_addresses_id ON orderlines_shipping (addresses_id);
CREATE INDEX orderlines_shipping_idx_orderlines_id ON orderlines_shipping (orderlines_id);
CREATE INDEX orderlines_shipping_idx_shipments_id ON orderlines_shipping (shipments_id);
--
-- Table: orders
--
CREATE TABLE orders (
  orders_id INTEGER PRIMARY KEY NOT NULL,
  order_number varchar(24) NOT NULL,
  order_date timestamp,
  users_id integer NOT NULL,
  email varchar(255) NOT NULL DEFAULT '',
  shipping_addresses_id integer NOT NULL,
  billing_addresses_id integer NOT NULL,
  weight numeric(11,3) NOT NULL DEFAULT 0.0,
  payment_method varchar(255) NOT NULL DEFAULT '',
  payment_number varchar(255) NOT NULL DEFAULT '',
  payment_status varchar(255) NOT NULL DEFAULT '',
  shipping_method varchar(255) NOT NULL DEFAULT '',
  subtotal numeric(11,2) NOT NULL DEFAULT 0.0,
  shipping numeric(11,2) NOT NULL DEFAULT 0.0,
  handling numeric(11,2) NOT NULL DEFAULT 0.0,
  salestax numeric(11,2) NOT NULL DEFAULT 0.0,
  total_cost numeric(11,2) NOT NULL DEFAULT 0.0,
  status varchar(24) NOT NULL DEFAULT '',
  FOREIGN KEY (billing_addresses_id) REFERENCES addresses(addresses_id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (shipping_addresses_id) REFERENCES addresses(addresses_id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (users_id) REFERENCES users(users_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX orders_idx_billing_addresses_id ON orders (billing_addresses_id);
CREATE INDEX orders_idx_shipping_addresses_id ON orders (shipping_addresses_id);
CREATE INDEX orders_idx_users_id ON orders (users_id);
CREATE UNIQUE INDEX orders_order_number_key ON orders (order_number);
--
-- Table: permissions
--
CREATE TABLE permissions (
  permissions_id INTEGER PRIMARY KEY NOT NULL,
  roles_id integer NOT NULL,
  perm varchar(255) NOT NULL DEFAULT '',
  FOREIGN KEY (roles_id) REFERENCES roles(roles_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX permissions_idx_roles_id ON permissions (roles_id);
--
-- Table: product_attributes
--
CREATE TABLE product_attributes (
  product_attributes_id INTEGER PRIMARY KEY NOT NULL,
  sku varchar(64) NOT NULL,
  attributes_id integer NOT NULL,
  canonical boolean NOT NULL DEFAULT 1,
  FOREIGN KEY (attributes_id) REFERENCES attributes(attributes_id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (sku) REFERENCES products(sku) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX product_attributes_idx_attributes_id ON product_attributes (attributes_id);
CREATE INDEX product_attributes_idx_sku ON product_attributes (sku);
--
-- Table: products
--
CREATE TABLE products (
  sku varchar(64) NOT NULL,
  name varchar(255) NOT NULL,
  short_description varchar(500) NOT NULL DEFAULT '',
  description text NOT NULL,
  price numeric(10,2) NOT NULL DEFAULT 0.0,
  uri varchar(255),
  weight numeric(10,2) NOT NULL DEFAULT 0.0,
  priority integer NOT NULL DEFAULT 0,
  gtin varchar(32),
  canonical_sku varchar(64),
  active boolean NOT NULL DEFAULT 1,
  inventory_exempt boolean NOT NULL DEFAULT 0,
  created datetime NOT NULL,
  last_modified datetime NOT NULL,
  PRIMARY KEY (sku),
  FOREIGN KEY (canonical_sku) REFERENCES products(sku)
);
CREATE INDEX products_idx_canonical_sku ON products (canonical_sku);
CREATE UNIQUE INDEX products_gtin ON products (gtin);
CREATE UNIQUE INDEX products_uri ON products (uri);
--
-- Table: products_attributes_values
--
CREATE TABLE products_attributes_values (
  product_attributes_values_id INTEGER PRIMARY KEY NOT NULL,
  product_attributes_id integer NOT NULL,
  attribute_values_id integer NOT NULL,
  FOREIGN KEY (attribute_values_id) REFERENCES attribute_values(attribute_values_id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (product_attributes_id) REFERENCES product_attributes(product_attributes_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX products_attributes_values_idx_attribute_values_id ON products_attributes_values (attribute_values_id);
CREATE INDEX products_attributes_values_idx_product_attributes_id ON products_attributes_values (product_attributes_id);
--
-- Table: roles
--
CREATE TABLE roles (
  roles_id INTEGER PRIMARY KEY NOT NULL,
  name varchar(32) NOT NULL,
  label varchar(255) NOT NULL
);
--
-- Table: sessions
--
CREATE TABLE sessions (
  sessions_id varchar(255) NOT NULL,
  session_data text NOT NULL,
  created datetime NOT NULL,
  last_modified datetime NOT NULL,
  PRIMARY KEY (sessions_id)
);
--
-- Table: settings
--
CREATE TABLE settings (
  settings_id INTEGER PRIMARY KEY NOT NULL,
  scope varchar(32) NOT NULL,
  site varchar(32) NOT NULL DEFAULT '',
  name varchar(32) NOT NULL,
  value text NOT NULL,
  category varchar(32) NOT NULL DEFAULT ''
);
--
-- Table: shipment_carriers
--
CREATE TABLE shipment_carriers (
  shipment_carriers_id INTEGER PRIMARY KEY NOT NULL,
  name varchar(255) NOT NULL DEFAULT '',
  title varchar(255) NOT NULL DEFAULT '',
  account_number varchar(255) NOT NULL DEFAULT '',
  active boolean NOT NULL DEFAULT 1
);
--
-- Table: shipment_destinations
--
CREATE TABLE shipment_destinations (
  shipment_destinations_id INTEGER PRIMARY KEY NOT NULL,
  zones_id integer NOT NULL,
  shipment_methods_id integer NOT NULL,
  active boolean NOT NULL DEFAULT 1,
  FOREIGN KEY (shipment_methods_id) REFERENCES shipment_methods(shipment_methods_id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (zones_id) REFERENCES zones(zones_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX shipment_destinations_idx_shipment_methods_id ON shipment_destinations (shipment_methods_id);
CREATE INDEX shipment_destinations_idx_zones_id ON shipment_destinations (zones_id);
--
-- Table: shipment_methods
--
CREATE TABLE shipment_methods (
  shipment_methods_id INTEGER PRIMARY KEY NOT NULL,
  name varchar(255) NOT NULL DEFAULT '',
  title varchar(255) NOT NULL DEFAULT '',
  min_weight numeric(10,2) NOT NULL DEFAULT 0.0,
  max_weight numeric(10,2) NOT NULL DEFAULT 0.0,
  shipment_carriers_id integer NOT NULL,
  active boolean NOT NULL DEFAULT 1,
  FOREIGN KEY (shipment_carriers_id) REFERENCES shipment_carriers(shipment_carriers_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX shipment_methods_idx_shipment_carriers_id ON shipment_methods (shipment_carriers_id);
--
-- Table: shipment_rates
--
CREATE TABLE shipment_rates (
  shipment_rates_id INTEGER PRIMARY KEY NOT NULL,
  zones_id integer NOT NULL,
  shipment_methods_id integer NOT NULL,
  min_weight numeric(10,2) NOT NULL DEFAULT 0.0,
  max_weight numeric(10,2) NOT NULL DEFAULT 0.0,
  price numeric(10,2) NOT NULL DEFAULT 0.0,
  created datetime NOT NULL,
  last_modified datetime NOT NULL,
  FOREIGN KEY (shipment_methods_id) REFERENCES shipment_methods(shipment_methods_id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (zones_id) REFERENCES zones(zones_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX shipment_rates_idx_shipment_methods_id ON shipment_rates (shipment_methods_id);
CREATE INDEX shipment_rates_idx_zones_id ON shipment_rates (zones_id);
--
-- Table: shipments
--
CREATE TABLE shipments (
  shipments_id INTEGER PRIMARY KEY NOT NULL,
  tracking_number varchar(255) NOT NULL DEFAULT '',
  shipment_carriers_id integer NOT NULL,
  shipment_methods_id integer NOT NULL,
  created datetime NOT NULL,
  last_modified datetime NOT NULL,
  FOREIGN KEY (shipment_carriers_id) REFERENCES shipment_carriers(shipment_carriers_id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (shipment_methods_id) REFERENCES shipment_methods(shipment_methods_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX shipments_idx_shipment_carriers_id ON shipments (shipment_carriers_id);
CREATE INDEX shipments_idx_shipment_methods_id ON shipments (shipment_methods_id);
--
-- Table: states
--
CREATE TABLE states (
  states_id INTEGER PRIMARY KEY NOT NULL,
  scope varchar(32) NOT NULL DEFAULT '',
  country_iso_code char(2) NOT NULL,
  state_iso_code varchar(6) NOT NULL DEFAULT '',
  name varchar(255) NOT NULL DEFAULT '',
  priority integer NOT NULL DEFAULT 0,
  active boolean NOT NULL DEFAULT 1,
  FOREIGN KEY (country_iso_code) REFERENCES countries(country_iso_code) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX states_idx_country_iso_code ON states (country_iso_code);
CREATE UNIQUE INDEX states_state_country ON states (country_iso_code, state_iso_code);
--
-- Table: taxes
--
CREATE TABLE taxes (
  taxes_id INTEGER PRIMARY KEY NOT NULL,
  tax_name varchar(64) NOT NULL,
  description varchar(64) NOT NULL,
  percent numeric(7,4) NOT NULL,
  decimal_places integer NOT NULL DEFAULT 2,
  rounding char(1),
  valid_from date NOT NULL,
  valid_to date,
  country_iso_code char(2),
  states_id integer,
  created datetime NOT NULL,
  last_modified datetime NOT NULL,
  FOREIGN KEY (country_iso_code) REFERENCES countries(country_iso_code) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (states_id) REFERENCES states(states_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX taxes_idx_country_iso_code ON taxes (country_iso_code);
CREATE INDEX taxes_idx_states_id ON taxes (states_id);
CREATE INDEX taxes_idx_tax_name ON taxes (tax_name);
CREATE INDEX taxes_idx_valid_from ON taxes (valid_from);
CREATE INDEX taxes_idx_valid_to ON taxes (valid_to);
--
-- Table: user_attributes
--
CREATE TABLE user_attributes (
  user_attributes_id INTEGER PRIMARY KEY NOT NULL,
  users_id integer NOT NULL,
  attributes_id integer NOT NULL,
  FOREIGN KEY (attributes_id) REFERENCES attributes(attributes_id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (users_id) REFERENCES users(users_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX user_attributes_idx_attributes_id ON user_attributes (attributes_id);
CREATE INDEX user_attributes_idx_users_id ON user_attributes (users_id);
--
-- Table: user_roles
--
CREATE TABLE user_roles (
  users_id integer NOT NULL,
  roles_id integer NOT NULL,
  PRIMARY KEY (users_id, roles_id),
  FOREIGN KEY (roles_id) REFERENCES roles(roles_id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (users_id) REFERENCES users(users_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX user_roles_idx_roles_id ON user_roles (roles_id);
CREATE INDEX user_roles_idx_users_id ON user_roles (users_id);
--
-- Table: users
--
CREATE TABLE users (
  users_id INTEGER PRIMARY KEY NOT NULL,
  username varchar(255) NOT NULL,
  nickname varchar(255),
  email varchar(255) NOT NULL DEFAULT '',
  password varchar(60) NOT NULL DEFAULT '',
  first_name varchar(255) NOT NULL DEFAULT '',
  last_name varchar(255) NOT NULL DEFAULT '',
  last_login datetime,
  fail_count integer NOT NULL DEFAULT 0,
  created datetime NOT NULL,
  last_modified datetime NOT NULL,
  active boolean NOT NULL DEFAULT 1
);
CREATE UNIQUE INDEX users_nickname ON users (nickname);
CREATE UNIQUE INDEX users_username ON users (username);
--
-- Table: users_attributes_values
--
CREATE TABLE users_attributes_values (
  user_attributes_values_id INTEGER PRIMARY KEY NOT NULL,
  user_attributes_id integer NOT NULL,
  attribute_values_id integer NOT NULL,
  FOREIGN KEY (attribute_values_id) REFERENCES attribute_values(attribute_values_id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (user_attributes_id) REFERENCES user_attributes(user_attributes_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX users_attributes_values_idx_attribute_values_id ON users_attributes_values (attribute_values_id);
CREATE INDEX users_attributes_values_idx_user_attributes_id ON users_attributes_values (user_attributes_id);
--
-- Table: zone_countries
--
CREATE TABLE zone_countries (
  zones_id integer NOT NULL,
  country_iso_code char(2) NOT NULL,
  PRIMARY KEY (zones_id, country_iso_code),
  FOREIGN KEY (country_iso_code) REFERENCES countries(country_iso_code) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (zones_id) REFERENCES zones(zones_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX zone_countries_idx_country_iso_code ON zone_countries (country_iso_code);
CREATE INDEX zone_countries_idx_zones_id ON zone_countries (zones_id);
--
-- Table: zone_states
--
CREATE TABLE zone_states (
  zones_id integer NOT NULL,
  states_id integer NOT NULL,
  PRIMARY KEY (zones_id, states_id),
  FOREIGN KEY (states_id) REFERENCES states(states_id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (zones_id) REFERENCES zones(zones_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX zone_states_idx_states_id ON zone_states (states_id);
CREATE INDEX zone_states_idx_zones_id ON zone_states (zones_id);
--
-- Table: zones
--
CREATE TABLE zones (
  zones_id INTEGER PRIMARY KEY NOT NULL,
  zone varchar(255) NOT NULL,
  created datetime NOT NULL,
  last_modified datetime NOT NULL
);
CREATE UNIQUE INDEX zones_zone ON zones (zone);
--
-- Table: payment_orders
--
CREATE TABLE payment_orders (
  payment_orders_id INTEGER PRIMARY KEY NOT NULL,
  payment_mode varchar(32) NOT NULL DEFAULT '',
  payment_action varchar(32) NOT NULL DEFAULT '',
  payment_id varchar(32) NOT NULL DEFAULT '',
  auth_code varchar(255) NOT NULL DEFAULT '',
  users_id integer,
  sessions_id varchar(255),
  orders_id integer,
  amount numeric(11,2) NOT NULL DEFAULT 0.0,
  status varchar(32) NOT NULL DEFAULT '',
  payment_sessions_id varchar(255) NOT NULL DEFAULT '',
  payment_error_code varchar(32) NOT NULL DEFAULT '',
  payment_error_message text,
  payment_fee numeric(11,2) NOT NULL DEFAULT 0.0,
  created datetime NOT NULL,
  last_modified datetime NOT NULL,
  FOREIGN KEY (orders_id) REFERENCES orders(orders_id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (sessions_id) REFERENCES sessions(sessions_id) ON DELETE SET NULL,
  FOREIGN KEY (users_id) REFERENCES users(users_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX payment_orders_idx_orders_id ON payment_orders (orders_id);
CREATE INDEX payment_orders_idx_sessions_id ON payment_orders (sessions_id);
CREATE INDEX payment_orders_idx_users_id ON payment_orders (users_id);
--
-- Table: media
--
CREATE TABLE media (
  media_id INTEGER PRIMARY KEY NOT NULL,
  file varchar(255) NOT NULL DEFAULT '',
  uri varchar(255) NOT NULL DEFAULT '',
  mime_type varchar(255) NOT NULL DEFAULT '',
  label varchar(255) NOT NULL DEFAULT '',
  author_users_id integer,
  created datetime NOT NULL,
  last_modified datetime NOT NULL,
  active boolean NOT NULL DEFAULT 1,
  media_types_id integer NOT NULL,
  FOREIGN KEY (author_users_id) REFERENCES users(users_id),
  FOREIGN KEY (media_types_id) REFERENCES media_types(media_types_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX media_idx_author_users_id ON media (author_users_id);
CREATE INDEX media_idx_media_types_id ON media (media_types_id);
CREATE UNIQUE INDEX media_file_unique ON media (file);
CREATE UNIQUE INDEX media_id_media_types_id_unique ON media (media_id, media_types_id);
--
-- Table: messages
--
CREATE TABLE messages (
  messages_id INTEGER PRIMARY KEY NOT NULL,
  title varchar(255) NOT NULL DEFAULT '',
  message_types_id integer NOT NULL,
  uri varchar(255),
  content text NOT NULL,
  author integer,
  rating numeric(4,2) NOT NULL DEFAULT 0,
  recommend boolean,
  public boolean NOT NULL DEFAULT 0,
  approved boolean NOT NULL DEFAULT 0,
  approved_by integer,
  created datetime NOT NULL,
  last_modified datetime NOT NULL,
  FOREIGN KEY (approved_by) REFERENCES users(users_id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (author) REFERENCES users(users_id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (message_types_id) REFERENCES message_types(message_types_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX messages_idx_approved_by ON messages (approved_by);
CREATE INDEX messages_idx_author ON messages (author);
CREATE INDEX messages_idx_message_types_id ON messages (message_types_id);
--
-- Table: order_comments
--
CREATE TABLE order_comments (
  messages_id integer NOT NULL,
  orders_id integer NOT NULL,
  PRIMARY KEY (messages_id, orders_id),
  FOREIGN KEY (messages_id) REFERENCES messages(messages_id) ON DELETE CASCADE,
  FOREIGN KEY (orders_id) REFERENCES orders(orders_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX order_comments_idx_messages_id ON order_comments (messages_id);
CREATE INDEX order_comments_idx_orders_id ON order_comments (orders_id);
--
-- Table: product_reviews
--
CREATE TABLE product_reviews (
  messages_id integer NOT NULL,
  sku varchar(64) NOT NULL,
  PRIMARY KEY (messages_id, sku),
  FOREIGN KEY (messages_id) REFERENCES messages(messages_id) ON DELETE CASCADE,
  FOREIGN KEY (sku) REFERENCES products(sku) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX product_reviews_idx_messages_id ON product_reviews (messages_id);
CREATE INDEX product_reviews_idx_sku ON product_reviews (sku);
COMMIT;
