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

class M_course_classes extends CI_Model {

	/**
	 * Primary key
	 * @var String
	 */
	public static $pk = 'id';

	/**
	 * Table
	 * @var String
	 */
	public static $table = 'course_classes';

	/**
	 * Get Subjects
	 * @param String $copy_data
	 * @param Integer $academic_year_id
	 * @param Integer $semester
	 * @param Integer $class_group_id
	 * @return Resource
	 */
	public function get_subjects($copy_data, $academic_year_id, $semester, $class_group_id) {
		$data = [];
		if (filter_var($copy_data, FILTER_VALIDATE_BOOLEAN)) {
			$query = $this->db
				->select('x2.id, x2.subject_name')
				->join('subjects x2', 'x1.subject_id = x2.id', 'LEFT')
				->where('x1.academic_year_id', _toInteger($academic_year_id))
				->where('x1.semester', $semester)
				->where('x1.class_group_id', _toInteger($class_group_id))
				->where('x1.is_deleted', 'false')
				->where('x2.is_deleted', 'false')
				->get(self::$table .' x1');
		} else {
			$query = $this->db
				->select('id, subject_name')
				->where('is_deleted', 'false')
				->get('subjects');
		}
		if ($query->num_rows() > 0) {
			foreach($query->result() as $row) {
				$data[] = [
					'id' => $row->id,
					'subject_name' => $row->subject_name
				];
			}
		}
		return $data;
	}

	/**
	 * Get Course Classes
	 * @param Integer $academic_year_id
	 * @param Integer $semester
	 * @param Integer $class_group_id
	 * @return Array
	 */
	public function get_course_classes($academic_year_id, $semester, $class_group_id) {
		$data = [];
		$query = $this->db
			->select("x1.id, x2.subject_name, COALESCE(x3.full_name, '[unset]') AS full_name, x1.is_deleted")
			->join('subjects x2', 'x1.subject_id = x2.id', 'LEFT')
			->join('users x3', 'x1.employee_id = x3.id', 'LEFT')
			->where('x1.academic_year_id', _toInteger($academic_year_id))
			->where('x1.semester', $semester)
			->where('x1.class_group_id', _toInteger($class_group_id))
			->get(self::$table .' x1');
		if ($query->num_rows() > 0) {
			foreach($query->result() as $row) {
				$data[] = [
					'id' => $row->id,
					'subject_name' => $row->subject_name,
					'full_name' => $row->full_name,
					'is_deleted' => $row->is_deleted
				];
			}
		}
		return $data;
	}

	/**
	 * Save to Destination Class
	 * @param Array $ids
	 * @param Integer $academic_year_id
	 * @param Integer $semester
	 * @param Integer $class_group_id
	 * @return Boolean
	 */
	public function save($ids, $academic_year_id, $semester, $class_group_id) {
		foreach ($ids as $subject_id) {
			$count = $this->db
				->where('academic_year_id', _toInteger($academic_year_id))
				->where('semester', $semester)
				->where('class_group_id', _toInteger($class_group_id))
				->where('subject_id', _toInteger($subject_id))
				->count_all_results(self::$table);
			if ($count === 0) {
				$this->db->set('academic_year_id', _toInteger($academic_year_id));
				$this->db->set('semester', $semester);
				$this->db->set('class_group_id', _toInteger($class_group_id));
				$this->db->set('subject_id', _toInteger($subject_id));
				$this->db->set('created_by', __session('user_id'));
				$query_string = $this->db->get_compiled_insert(self::$table);
				$query_string = str_replace('INSERT INTO', 'INSERT IGNORE INTO', $query_string);
        		$this->db->query($query_string);
			}
		}
		return TRUE;
	}

	/**
	 * Change Deleted Status
	 * @param Array $course_class_ids
	 * @param Integer $academic_year_id
	 * @param Integer $semester
	 * @param Integer $class_group_id
	 * @param Integer $is_deleted
	 * @return Boolean
	 */
	public function change_deleted_status($course_class_ids, $academic_year_id, $semester, $class_group_id, $is_deleted = 'true') {
		$success = FALSE;
		foreach ($course_class_ids as $course_class_id) {
			// Get Subject ID
			$subject = $this->model->RowObject('id', $course_class_id, 'course_classes');
			$subject_id = $subject->subject_id;
			// Get Class Metting ID
			$class_meeting_id = 0;
			$class_meeting = $this->db
				->select('id')
				->where('course_class_id', _toInteger($course_class_id))
				->get('class_meetings');
			if ($class_meeting->num_rows() == 1) {
				$res = $class_meeting->row();
				$class_meeting_id = $res->id;
			}
			// Delete Course Classes
			$this->db->set('is_deleted', $is_deleted);
			$this->db->where('academic_year_id', _toInteger($academic_year_id));
			$this->db->where('semester', $semester);
			$this->db->where('class_group_id', _toInteger($class_group_id));
			$this->db->where('subject_id', _toInteger($subject_id));
			$query = $this->db->update(self::$table);
			if ($query && $course_class_id > 0) {
				$success = TRUE;
				// Delete Class Meetings
				$this->db->set('is_deleted', $is_deleted);
				$this->db->where('course_class_id', _toInteger($course_class_id));
				$query = $this->db->update('class_meetings');
				if ($query && $class_meeting_id > 0) {
					// Delete Meeting Attendences
					$this->db->set('is_deleted', $is_deleted);
					$this->db->where('class_meeting_id', _toInteger($class_meeting_id));
					$this->db->update('meeting_attendences');
				}
			}
		}
		return $success > 0;
	}

	/**
	 * Get Course Classes By ID
	 * @param Integer $id
	 * @return Resource
	 */
	public function get_course_classes_by_id($id) {
		return $this->db
			->select("
				x1.id
				, x2.academic_year
				, IF(x1.semester = 'odd', 'Ganjil', 'Genap') AS semester
				, CONCAT(x3.class_group, IF((x4.major_short_name <> ''), CONCAT(' ',x4.major_short_name),''),IF((x3.sub_class_group <> ''),CONCAT(' - ',x3.sub_class_group),'')) class_group
				, x5.subject_name
				, x6.full_name
			")
			->join('academic_years x2', 'x1.academic_year_id = x2.id', 'LEFT')
			->join('class_groups x3', 'x1.class_group_id = x3.id', 'LEFT')
			->join('majors x4', 'x3.major_id = x4.id', 'LEFT')
			->join('subjects x5', 'x1.subject_id = x5.id', 'LEFT')
			->join('users x6', 'x1.employee_id = x6.id', 'LEFT')
			->where('x1.id', $id)
			->get('course_classes x1')
			->row();
	}

	/**
	 * Get Course Class ID
	 * @param Integer $academic_year_id
	 * @param String $semester
	 * @param Integer $class_group_id
	 * @param Integer $subject_id
	 * @param Integer $employee_id
	 * @return Integer
	 */
	public function find_id($academic_year_id, $semester, $class_group_id, $subject_id, $employee_id) {
		$query = $this->db
			->select('id')
			->where('academic_year_id', _toInteger($academic_year_id))
			->where('semester', $semester)
			->where('class_group_id', _toInteger($class_group_id))
			->where('subject_id', (int) $subject_id)
			->where('employee_id', (int) $employee_id)
			->get('course_classes');
		if ($query->num_rows() === 1) {
			$res = $query->row();
			return $res->id;
		}
		return 0;
	}
}
