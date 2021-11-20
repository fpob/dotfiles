layout_ansible () {
    local base_dir="$(direnv_layout_dir)/ansible"
    mkdir -p "$base_dir"

    path_add ANSIBLE_COLLECTIONS_PATH "$base_dir/collections"
    path_add ANSIBLE_ROLES_PATH "$base_dir/roles"
}
