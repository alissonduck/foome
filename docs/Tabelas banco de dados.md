| table_name            | column_name            | data_type                   |
| --------------------- | ---------------------- | --------------------------- |
| Atom                  | active                 | boolean                     |
| PartnerCategory       | id                     | bigint                      |
| PartnerCategory       | created_at             | timestamp with time zone    |
| PartnerCategory       | partner_id             | integer                     |
| PartnerCategory       | category_id            | bigint                      |
| PartnerUsers          | id                     | integer                     |
| PartnerUsers          | partner_id             | integer                     |
| PartnerUsers          | created_at             | timestamp without time zone |
| PartnerUsers          | updated_at             | timestamp without time zone |
| PartnerUsers          | active                 | boolean                     |
| Partner               | id                     | integer                     |
| Partner               | google_infos           | jsonb                       |
| Partner               | city_id                | integer                     |
| Partner               | active                 | boolean                     |
| Partner               | created_at             | timestamp without time zone |
| Partner               | updated_at             | timestamp without time zone |
| Partner               | terms_accepted         | boolean                     |
| Partner               | chairs                 | integer                     |
| Partner               | days_of_week           | jsonb                       |
| Partner               | instagram_infos        | jsonb                       |
| Partner               | onboarding_completed   | boolean                     |
| Partner               | activated_at           | date                        |
| Partner               | disabled_at            | date                        |
| PartnerCuisine        | id                     | bigint                      |
| PartnerCuisine        | created_at             | timestamp with time zone    |
| PartnerCuisine        | partner_id             | integer                     |
| PartnerCuisine        | cuisine_type_id        | bigint                      |
| PartnerCharacteristic | id                     | bigint                      |
| PartnerCharacteristic | created_at             | timestamp with time zone    |
| PartnerCharacteristic | characteristic_id      | bigint                      |
| PartnerCharacteristic | partner_id             | integer                     |
| Admin                 | id                     | integer                     |
| Admin                 | created_at             | timestamp with time zone    |
| Admin                 | updated_at             | timestamp with time zone    |
| Category              | id                     | bigint                      |
| Category              | created_at             | timestamp with time zone    |
| Atom                  | id                     | bigint                      |
| Atom                  | created_at             | timestamp with time zone    |
| Atom                  | admin_id               | integer                     |
| State                 | id                     | integer                     |
| City                  | id                     | integer                     |
| City                  | state_id               | integer                     |
| Characteristic        | id                     | bigint                      |
| Characteristic        | created_at             | timestamp with time zone    |
| AtomNetwork           | id                     | bigint                      |
| AtomNetwork           | created_at             | timestamp with time zone    |
| AtomNetwork           | office_id              | integer                     |
| AtomNetwork           | partner_id             | integer                     |
| AtomNetwork           | atom_id                | bigint                      |
| Company               | id                     | integer                     |
| Company               | max_users              | integer                     |
| Company               | active                 | boolean                     |
| Company               | created_at             | timestamp without time zone |
| Company               | updated_at             | timestamp without time zone |
| Team                  | id                     | integer                     |
| Team                  | company_id             | integer                     |
| Team                  | manager_id             | integer                     |
| Team                  | active                 | boolean                     |
| Team                  | created_at             | timestamp without time zone |
| Team                  | updated_at             | timestamp without time zone |
| Employee              | id                     | integer                     |
| Employee              | company_id             | integer                     |
| Employee              | birth_date             | date                        |
| Employee              | internal_id            | integer                     |
| Employee              | active                 | boolean                     |
| Employee              | created_at             | timestamp without time zone |
| Employee              | updated_at             | timestamp without time zone |
| Employee              | team_id                | integer                     |
| Employee              | office_id              | integer                     |
| AdminSettings         | id                     | bigint                      |
| AdminSettings         | created_at             | timestamp with time zone    |
| AdminSettings         | min_discount_percent   | double precision            |
| AdminSettings         | min_discount_value     | double precision            |
| CuisineType           | id                     | bigint                      |
| CuisineType           | created_at             | timestamp with time zone    |
| Office                | id                     | integer                     |
| Office                | company_id             | integer                     |
| Office                | city_id                | integer                     |
| Office                | google_infos           | jsonb                       |
| Office                | active                 | boolean                     |
| Office                | created_at             | timestamp without time zone |
| Office                | updated_at             | timestamp without time zone |
| Office                | zip_code               | bigint                      |
| Office                | number                 | bigint                      |
| Promotion               | id                     | integer                     |
| Promotion               | partner_id             | integer                     |
| Promotion               | value                  | numeric                     |
| Promotion               | min_purchase           | numeric                     |
| Promotion               | valid_from             | date                        |
| Promotion               | valid_to               | date                        |
| Promotion               | days_of_week           | jsonb                       |
| Promotion               | time_range             | jsonb                       |
| Promotion               | active                 | boolean                     |
| Promotion               | created_at             | timestamp without time zone |
| Promotion               | updated_at             | timestamp without time zone |
| Promotion               | item_sale_price        | numeric                     |
| Promotion               | item_cost              | numeric                     |
| Voucher           | id                     | integer                     |
| Voucher           | voucher_id             | integer                     |
| Voucher           | employee_id            | integer                     |
| Voucher           | original_price         | numeric                     |
| Voucher           | discount_amount        | numeric                     |
| Voucher           | final_price            | numeric                     |
| Voucher           | used_at                | timestamp without time zone |
| Reviews               | id                     | integer                     |
| Reviews               | voucher_used_id        | integer                     |
| Reviews               | partner_id             | integer                     |
| Reviews               | score                  | smallint                    |
| Reviews               | created_at             | timestamp without time zone |
| State                 | name                   | character varying           |
| State                 | abbreviation           | character varying           |
| PartnerUsers          | name                   | text                        |
| City                  | name                   | character varying           |
| Partner               | instagram              | text                        |
| Partner               | name                   | character varying           |
| Admin                 | phone                  | text                        |
| Characteristic        | name                   | text                        |
| Reviews               | feedback               | text                        |
| Admin                 | role                   | text                        |
| Partner               | logo_url               | text                        |
| AdminSettings         | name                   | text                        |
| Partner               | logo_image             | text                        |
| Partner               | cover_image            | text                        |
| Company               | name                   | character varying           |
| Company               | employee_count_range   | character varying           |
| CuisineType           | name                   | text                        |
| Partner               | neighborhood           | text                        |
| Office                | name                   | character varying           |
| Partner               | description            | text                        |
| Company               | work_regime            | text                        |
| Company               | cnpj                   | text                        |
| Promotion               | scheduled_deactivation | text                        |
| Partner               | cnpj                   | character varying           |
| Team                  | name                   | character varying           |
| Category              | name                   | text                        |
| PartnerUsers          | role                   | character varying           |
| PartnerUsers          | phone                  | character varying           |
| Office                | neighborhood           | text                        |
| Atom                  | name                   | text                        |
| Admin                 | full_name              | text                        |
| Partner               | google_place_id        | text                        |
| Employee              | name                   | character varying           |
| Employee              | phone                  | character varying           |
| Employee              | cpf                    | character varying           |
| Voucher           | status                 | text                        |
| Promotion               | name                   | character varying           |
| Employee              | role                   | character varying           |
| Employee              | role_name              | character varying           |
| Promotion               | description            | text                        |
| Promotion               | type                   | character varying           |