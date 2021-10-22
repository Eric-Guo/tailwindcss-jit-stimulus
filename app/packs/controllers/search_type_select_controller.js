import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  all_as_material() {
    document.getElementById('search-form').action = '/search/material';
    const current_node_class = document.getElementById('div-select-all-as-material').classList;
    this.remove_active();
    if(!current_node_class.contains('active-search')) {
      current_node_class.remove('cursor-pointer');
      current_node_class.add('active-search');
      document.getElementById('search-box').placeholder = '黄金麻/镀膜玻璃/PC板/项目名称/东丽石业';
    }
  }

  materials() {
    document.getElementById('search-form').action = '/search/material';
    const current_node_class = document.getElementById('div-select-materials').classList;
    this.remove_active();
    if(!current_node_class.contains('active-search')) {
      current_node_class.remove('cursor-pointer');
      current_node_class.add('active-search');
      document.getElementById('search-box').placeholder = '黄金麻/镀膜玻璃/PC板';
    }
  }

  projects() {
    document.getElementById('search-form').action = '/search/project';
    const current_node_class = document.getElementById('div-select-projects').classList;
    this.remove_active();
    if(!current_node_class.contains('active-search')) {
      current_node_class.remove('cursor-pointer');
      current_node_class.add('active-search');
      document.getElementById('search-box').placeholder = '项目名称';
    }
  }

  manufacturer() {
    document.getElementById('search-form').action = '/search/manufacturer';
    const current_node_class = document.getElementById('div-select-manufacturer').classList;
    this.remove_active();
    if(!current_node_class.contains('active-search')) {
      current_node_class.remove('cursor-pointer');
      current_node_class.add('active-search');
      document.getElementById('search-box').placeholder = '东丽石业';
    }

  }

  remove_active() {
    const c0 = document.getElementById('div-select-all-as-material').classList;
    c0.remove('active-search');
    c0.add('cursor-pointer');
    const c1 = document.getElementById('div-select-materials').classList;
    c1.remove('active-search');
    c1.add('cursor-pointer');
    const c2 = document.getElementById('div-select-projects').classList
    c2.remove('active-search');
    c2.add('cursor-pointer');
    const c3 = document.getElementById('div-select-manufacturer').classList;
    c3.remove('active-search');
    c3.add('cursor-pointer');
  }
}
