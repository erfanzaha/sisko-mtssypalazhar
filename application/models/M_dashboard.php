<?php defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * CMS Sekolahku Premium Version
 * @version    2.5.4
 * @author     Anton Sofyan | https://facebook.com/antonsofyan | 4ntonsofyan@gmail.com | 0857 5988 8922
 * @copyright  (c) 2017-2023
 * @link       https://sekolahku.web.id
 *
 * PERINGATAN :
 * 1. TIDAK DIPERKENANKAN MENGGUNAKAN CMS INI TANPA SEIZIN DARI PIHAK PENGEMBANG APLIKASI.
 * 2. TIDAK DIPERKENANKAN MEMPERJUALBELIKAN APLIKASI INI TANPA SEIZIN DARI PIHAK PENGEMBANG APLIKASI.
 * 3. TIDAK DIPERKENANKAN MENGHAPUS KODE SUMBER APLIKASI.
 */

class M_dashboard extends CI_Model {

	/**
	 * Get Data
	 * @return Resource
	 */
	public function widget_box() {
		$query = $this->db->query("
			SELECT (SELECT COUNT(*) FROM comments x1 WHERE x1.comment_type='message') AS messages
			, (SELECT COUNT(*) FROM comments x1 WHERE x1.comment_type='post') AS comments
			, (SELECT COUNT(*) FROM posts x1 WHERE x1.post_type='post') AS posts
			, (SELECT COUNT(*) FROM posts x1 WHERE x1.post_type='page') AS pages
			, (SELECT COUNT(*) FROM categories WHERE category_type='post') AS categories
			, (SELECT COUNT(*) FROM tags) AS tags
			, (SELECT COUNT(*) FROM links WHERE link_type = 'link') AS links
			, (SELECT COUNT(*) FROM quotes) AS quotes
		");
		return $query->row();
	}
}
