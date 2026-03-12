class CreatePageTranslations < ActiveRecord::Migration[8.1]
  def up
    create_table :page_translations do |t|
      t.references :page, null: false, foreign_key: true
      t.string :locale, null: false
      t.string :title, null: false

      t.timestamps
    end

    add_index :page_translations, [:page_id, :locale], unique: true

    # Migrate existing data
    Page.all.each do |page|
      translation = PageTranslation.create!(
        page: page,
        locale: 'en',
        title: page.title,
        created_at: page.created_at,
        updated_at: page.updated_at
      )
      
      # Migrate ActionText content
      if page.content.present?
        translation.content = page.content.body
        translation.save!
      end
    end

    # Note: We keep title and content on Page for now, but we could remove them in a later migration.
    # To keep it simple, we'll keep them as fallback or just ignore them.
    # Actually, if we're moving to translations, we should ideally remove them to avoid confusion.
    # But removing columns in the same migration as data migration can be risky if rollback is needed.
  end

  def down
    drop_table :page_translations
  end
end
