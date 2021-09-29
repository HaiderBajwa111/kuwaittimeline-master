ActiveAdmin.register Post do
    active_admin_import  back: {action: :import},
    csv_options: {col_sep: ","},
    template: "admin/import",
    batch_size: 1000,
    validate: true

    csv do
      column :id
      column :subject_ar
      column :subject_en
      column :description_ar
      column :description_en
      column :reference 
      column :timestamp
      column :date
      column :hide_day
      column :hide_month  
      column :time  
      column :status
      column :flag
      column :views
      column :created_at
      column :updated_at
      column :category_ids
    end


  config.scope :pending, default: true
  config.scope :flagged
  config.scope :approved
  index do
    selectable_column
    id_column
    column :subject_ar
    column :subject_en
    column :description_ar
    column :description_en
    column :reference 
    column :timestamp
    column :date  
    column :time  
    column :status
    column :flag
    column :views
    column :created_at
    column :updated_at
    column :categories
    column :user
    column :actions do |item|
      links = []
      links << link_to('Show', admin_post_path(item))
      links << link_to('Edit', edit_admin_post_path(item))
      links << link_to('Delete', admin_post_path(item), method: :delete, confirm: 'Are you sure?')
      links << link_to('Approve', admin_post_approve_path(item), method: :post) if item.status != 'approved'
      links.join(' ').html_safe
    end
  end
    controller do 

      def do_import
        errors,success,failure = Post.import(params[:active_admin_import_model][:file])
        flash[:notice] = "Successfully created #{success} post(s)" if success > 0
        flash[:error] = "Failed to create #{failure} post(s)" if failure > 0
        if errors.any?
          flash[:alert] = errors
        end
        redirect_to admin_posts_path
      end

      def approve
        post = Post.find(params[:id])
        post.status = 'approved'
        post.save
        redirect_to admin_posts_path
      end
    end
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :subject_ar, :subject_en, :description_ar, :description_en, :reference, :date, :time, :flag, :hide_day, :hide_month, :picture, :status, category_ids: []
  #
  # or
  #
  # permit_params do
  #   permitted = [:category_ids, :subject_ar, :subject_en, :description_ar, :description_en, :reference, :timestamp, :date, :time, :flag, :status, :views]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  form do |f|
    f.inputs do
      f.input :status, as: :select, collection: Post.status_choices.map {|s| [s.capitalize, s] }
      f.input :subject_ar
      f.input :subject_en
      f.input :categories, input_html: {multiple: true}
      f.input :description_ar
      f.input :description_en
      f.input :reference
      f.input :hide_day
      f.input :hide_month
      f.input :date, as: :datepicker
      f.input :time, label: "Time"
      f.input :picture, as: :file
    end
    f.actions
  end

  batch_action :approve, if: proc { @current_scope.scope_method == :pending }  do |ids|
    batch_action_collection.find(ids).each do |post|
      post.status = 'approved'
      post.save
    end
    redirect_to collection_path, alert: "The posts have been approved."
  end
  
end
